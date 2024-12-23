//
//  ScannerViewModel.swift
//  RetailScanner
//
//  Created by Gokul Gopalakrishnan on 21/12/24.
//

import Foundation

class ScannerViewModel {
    
    var entryPoint: String = ""
    
    public func fetchData(payload: [String: Any]) {
        if let entryPoint = payload["entryPoint"] as? String {
            self.entryPoint = entryPoint
        }
    }
    
    public func barcodeReliabilityCheck(barcodeData: String) -> Bool {
        let inventoryAvailableData: [inventoryDataModel] = inventoryVariables.commonInventoryDetails.filter({ $0.barcodeNumber == barcodeData})
        
        if inventoryAvailableData.count > 0 {
            let retailData = retailBillingDataModel(barcodeNumber: barcodeData, category: inventoryAvailableData[0].category , cost: inventoryAvailableData[0].cost )
            retailVariable.commonRetailDetails.append(retailData)
            return true
        } else {
            return false
        }
    }
    
    public func duplicateBarcodeCheck(barcodeData: String) -> Bool {
        let retainAvailableData = retailVariable.commonRetailDetails.filter({ $0.barcodeNumber == barcodeData })
        
        if retainAvailableData.count >= 1 {
            if let row = retailVariable.commonRetailDetails.firstIndex(where: {$0.barcodeNumber == barcodeData}) {
                retailVariable.commonRetailDetails[row].quantity += 1
            }
            return true
            
        } else {
            return false
        }
    }
    
    public func authenticityBarcode(barcodedata: String) -> Bool {
        if let auth = Int(barcodedata) {
            return true
        } else {
            return false
        }
    }
    
}
