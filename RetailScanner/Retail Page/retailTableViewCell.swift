//
//  retailTableViewCell.swift
//  RetailScanner
//
//  Created by Gokul Gopalakrishnan on 22/12/24.
//

import UIKit

protocol retailBillingDelegate {
    func addingQuantity(index: Int)
    func reducingQuantity(index: Int)
}

class retailTableViewCell: UITableViewCell {

    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var QuantityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var index = 0
    
    var delegate: retailBillingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(cost: String, quantity: Int, category: String) {
        costLabel.text = cost
        QuantityLabel.text =  "\(String(quantity))x"
        categoryLabel.text = category
    }
    
    @IBAction func minusButton(_ sender: Any) {
        self.delegate?.reducingQuantity(index: index)
    }
    
    @IBAction func plusButton(_ sender: Any) {
        self.delegate?.addingQuantity(index: index)
    }
}
