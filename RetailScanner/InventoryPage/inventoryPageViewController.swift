//
//  inventoryPageViewController.swift
//  RetailScanner
//
//  Created by Gokul Gopalakrishnan on 21/12/24.
//

import UIKit

class inventoryPageViewController: UIViewController {

    @IBOutlet weak var inventoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Inventory Scanner"

        let nib = UINib(nibName: "inventoryTableViewCell", bundle: nil)
        inventoryTableView.register(nib, forCellReuseIdentifier: "inventoryTableViewCell")
        
        inventoryTableView.delegate = self
        inventoryTableView.dataSource = self
        inventoryTableView.reloadData()
        
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(scannerTapped))
        
        view.addSubview(yourLabel)
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inventoryTableView.reloadData()
    }
    
    @objc func scannerTapped() {
        let barcodeNavigation = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        barcodeNavigation.payload = ["entryPoint": RetailConstants.fromInventory]
        self.navigationController?.pushViewController(barcodeNavigation, animated: true)
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
}


extension inventoryPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nothingToshow()
        return inventoryVariables.commonInventoryDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = tableView.dequeueReusableCell(withIdentifier: "inventoryTableViewCell", for: indexPath) as! inventoryTableViewCell
        cells.delegate = self
        cells.index = indexPath.row
        cells.config(barcode: inventoryVariables.commonInventoryDetails[indexPath.row].barcodeNumber, category: inventoryVariables.commonInventoryDetails[indexPath.row].category, cost: inventoryVariables.commonInventoryDetails[indexPath.row].cost)
     
        return cells
    }
}


extension inventoryPageViewController: inventoryDelegates {
    func removeBarcodeFromInventory(index: Int) {
        inventoryVariables.commonInventoryDetails.remove(at: index)
        inventoryTableView.reloadData()
    }
    
    func nothingToshow() {
        if inventoryVariables.commonInventoryDetails.count > 0 {
            yourLabel.isHidden = true
        } else {
            yourLabel.isHidden = false
        }
    }
    
}
