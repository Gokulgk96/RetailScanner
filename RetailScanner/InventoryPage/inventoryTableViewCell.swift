//
//  inventoryTableViewCell.swift
//  RetailScanner
//
//  Created by Gokul Gopalakrishnan on 22/12/24.
//

import UIKit

protocol inventoryDelegates {
    func removeBarcodeFromInventory(index: Int)
}

class inventoryTableViewCell: UITableViewCell {

    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var CostLabel: UILabel!
    var index: Int = 0
    
    var delegate: inventoryDelegates?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func config(barcode: String, category: String, cost: String) {
        barcodeLabel.text = barcode
        categoryLabel.text = category
        CostLabel.text = cost
    }
    
    @IBAction func removeBarcode(_ sender: Any) {
        self.delegate?.removeBarcodeFromInventory(index: index)
    }
}
