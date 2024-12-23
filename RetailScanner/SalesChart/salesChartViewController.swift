//
//  salesChartViewController.swift
//  RetailScanner
//
//  Created by Gokul Gopalakrishnan on 23/12/24.
//

import UIKit

class salesChartViewController: UIViewController {
    
    @IBOutlet weak var salesHisoryTabelview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        salesHisoryTabelview.delegate = self
        salesHisoryTabelview.dataSource = self
        salesHisoryTabelview.reloadData()
        self.title = "History Scanner"
        let nib = UINib(nibName: "historyTableViewCell", bundle: nil)
        salesHisoryTabelview.register(nib, forCellReuseIdentifier: "historyTableViewCell")
        
        view.addSubview(yourLabel)
        setupLayout()
    }
    
    let yourLabel: UILabel = {
      let label = UILabel()
      label.text = "No sales history to show Yet!!!"
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


extension salesChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nothingToshow()
        return salesHistoryVariables.commonHistoryDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = tableView.dequeueReusableCell(withIdentifier: "historyTableViewCell", for: indexPath) as! historyTableViewCell

        cells.config(customerLabel: salesHistoryVariables.commonHistoryDetails[indexPath.row].customerName, totalAmount: salesHistoryVariables.commonHistoryDetails[indexPath.row].totalAmount)
     
        return cells
    }
    
    func nothingToshow() {
        if salesHistoryVariables.commonHistoryDetails.count > 0 {
            yourLabel.isHidden = true
        } else {
            yourLabel.isHidden = false
        }
    }
}
