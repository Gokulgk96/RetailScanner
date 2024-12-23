//
//  ViewController.swift
//  RetailScanner
//
//  Created by Gokul Gopalakrishnan on 21/12/24.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func inventoryListClick(_ sender: Any) {
        let inventoryPagenavigation = self.storyboard?.instantiateViewController(withIdentifier: "inventoryPageViewController") as! inventoryPageViewController
        
        self.navigationController?.pushViewController(inventoryPagenavigation, animated: true)
    }
    
    @IBAction func barcodeclick(_ sender: Any) {
        let retailBillingNavigation = self.storyboard?.instantiateViewController(withIdentifier: "RetailBiilingViewController") as! RetailBiilingViewController
        
        self.navigationController?.pushViewController(retailBillingNavigation, animated: true)
        
        
    }
    
    
    @IBAction func salesHistory(_ sender: Any) {
        let salesHistoryNavigation = self.storyboard?.instantiateViewController(withIdentifier: "salesChartViewController") as! salesChartViewController
        
        self.navigationController?.pushViewController(salesHistoryNavigation, animated: true)
    }
}

