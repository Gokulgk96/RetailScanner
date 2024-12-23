//
//  historyTableViewCell.swift
//  RetailScanner
//
//  Created by Gokul Gopalakrishnan on 23/12/24.
//

import UIKit

class historyTableViewCell: UITableViewCell {

    @IBOutlet weak var totalCost: UILabel!

    @IBOutlet weak var customerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func config(customerLabel: String, totalAmount: String) {
        totalCost.text = totalAmount
        customerName.text = customerLabel
    }
    
}
