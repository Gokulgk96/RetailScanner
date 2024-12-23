//
//  overlayViewController.swift
//  RetailScanner
//
//  Created by Gokul Gopalakrishnan on 21/12/24.
//

import UIKit

protocol ovelayDelegate {
    func triggerAV()
}

class overlayViewController: UIViewController {
    
    var barcodeValue: String? = ""

    @IBOutlet weak var mainContentView: UIView!
    
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var costText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    
    var viewModel = overlayViewModel()
    
    var delegate: ovelayDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barcodeLabel.text = "Barcode: \(String(describing: barcodeValue ?? ""))"
        categoryText.keyboardType = .asciiCapable
        costText.keyboardType = .numberPad
        
        mainContentView.layer.cornerRadius = 20
        
    }

    @IBAction func buttonOverLay(_ sender: Any) {
        
        
        if let barcodesValue = barcodeValue, let category = categoryText.text, let cost = costText.text {
            if !viewModel.textBoxValidation(category: category, cost: cost) {
                // set Alert
                let alert = UIAlertController(title: "ALERT", message: "Please Enter All the Details", preferredStyle: UIAlertController.Style.alert)
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                // change to desired number of seconds (in this case 5 seconds)
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when) {
                    // your code with delay
                    alert.dismiss(animated: true, completion: nil)
                }

            } else {
                let inventoryDataModel = inventoryDataModel(barcodeNumber: barcodesValue, category: category, cost: cost)
                inventoryVariables.commonInventoryDetails.append(inventoryDataModel)
            }
           
        }
        
        self.dismiss(animated: true, completion: {
            self.delegate?.triggerAV()
        })
    }
    
    @IBAction func dismissOverlay(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.triggerAV()
        })
    }
}
