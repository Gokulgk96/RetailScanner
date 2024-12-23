//
//  RetailBiilingViewController.swift
//  RetailScanner
//
//  Created by Gokul Gopalakrishnan on 21/12/24.
//

import UIKit

class RetailBiilingViewController: UIViewController {

    @IBOutlet weak var retailObjects: UITableView!
    
    @IBOutlet weak var floatingBottomButton: UIButton!
    
    var viewModel = RetailBillingViewModel()
    
    var TotalAmount: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Retail Scanner"
        
        let nib = UINib(nibName: "retailTableViewCell", bundle: nil)
        retailObjects.register(nib, forCellReuseIdentifier: "retailTableViewCell")
        
        retailObjects.delegate = self
        retailObjects.dataSource = self
        
        if retailVariable.commonRetailDetails.count > 0 {
            floatingBottomButton.isHidden = false
            floatingBottomButton.titleLabel?.text = "Proceed to Pay \(viewModel.calculateFullPayment(paymentData: retailVariable.commonRetailDetails))\u{20B9}"
            
        } else {
            floatingBottomButton.isHidden = true
        }

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
        view.addSubview(yourLabel)
        setupLayout()
    }
    
    @IBAction func FloatingButtonCheck(_ sender: Any) {
        showAlert()
    }
    
    let yourLabel: UILabel = {
      let label = UILabel()
      label.text = "Nothing to Show, Please Click the \"Add\" Button in the Top left to scan"
      label.font = UIFont.boldSystemFont(ofSize: 26)
      label.textColor =  .red
      label.translatesAutoresizingMaskIntoConstraints = false
      label.numberOfLines = 0
      label.lineBreakMode = NSLineBreakMode.byWordWrapping
                    
      label.sizeToFit()
               
      return label
    }()
    
    private func setupLayout() {
        yourLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        yourLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        yourLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        yourLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    @objc func addTapped() {
        let barcodeNavigation = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        self.navigationController?.pushViewController(barcodeNavigation, animated: true)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            retailObjects.reloadData()
        
        if retailVariable.commonRetailDetails.count > 0 {
            floatingBottomButton.isHidden = false
            TotalAmount = "\u{20B9}\(viewModel.calculateFullPayment(paymentData: retailVariable.commonRetailDetails))"
            let buttonString = "Proceed to Pay \(TotalAmount)"
            floatingBottomButton.setTitle(buttonString, for: .normal)
        } else {
            floatingBottomButton.isHidden = true
        }
    }
  
}

extension RetailBiilingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nothingToshow()
        return retailVariable.commonRetailDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = tableView.dequeueReusableCell(withIdentifier: "retailTableViewCell", for: indexPath) as! retailTableViewCell
        cells.delegate = self
        cells.index = indexPath.row
        cells.config(cost: retailVariable.commonRetailDetails[indexPath.row].cost, quantity: retailVariable.commonRetailDetails[indexPath.row].quantity, category: retailVariable.commonRetailDetails[indexPath.row].category)
        return cells
    }
    
    
}

extension RetailBiilingViewController: retailBillingDelegate {
    func addingQuantity(index: Int) {
        
        retailVariable.commonRetailDetails[index].quantity += 1
        updateTheFloatingButton()
        retailObjects.reloadData()
    }
    
    func reducingQuantity(index: Int) {
        let quantityCount = retailVariable.commonRetailDetails[index].quantity
        if (quantityCount == 1 ) {
            retailVariable.commonRetailDetails.remove(at: index)
        } else {
            retailVariable.commonRetailDetails[index].quantity -= 1
        }
        updateTheFloatingButton()
        retailObjects.reloadData()
    }
}


extension RetailBiilingViewController {
    
    func updateTheFloatingButton() {
        TotalAmount = "\u{20B9}\(viewModel.calculateFullPayment(paymentData: retailVariable.commonRetailDetails))"
        let buttonString = "Proceed to Pay \(TotalAmount)"
        
        floatingBottomButton.setTitle(buttonString, for: .normal)
    }
    
    func nothingToshow() {
        if retailVariable.commonRetailDetails.count > 0 {
            yourLabel.isHidden = true
        } else {
            yourLabel.isHidden = false
            floatingBottomButton.isHidden = true
        }
    }
    
    
    func showAlert() {
        let momentInTime = Date()
        let historyData = salesChartHistoryDataModel(customerName: "\(momentInTime)", totalAmount: TotalAmount)
        salesHistoryVariables.commonHistoryDetails.append(historyData)
        
           let alert = UIAlertController(title: "Payment Done Congrats", message: "Changes are added in the history Table", preferredStyle: .alert)
             
           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
               print("Ok")
               
           }))
           
            
           DispatchQueue.main.async {
               self.present(alert, animated: false, completion: {
                   retailVariable.commonRetailDetails = []
                   self.retailObjects.reloadData()
               })
           }
             
       }
}
