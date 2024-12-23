//
//  overlayViewModel.swift
//  RetailScanner
//
//  Created by Gokul Gopalakrishnan on 22/12/24.
//

import Foundation

class overlayViewModel {
    
    public func textBoxValidation(category: String, cost: String) -> Bool {
        
        if category.isEmpty || cost.isEmpty {
            return false
        }
        
        return true
    }
}
