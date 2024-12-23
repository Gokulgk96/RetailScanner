//
//  RetailBillingViewModel.swift
//  RetailScanner
//
//  Created by Gokul Gopalakrishnan on 22/12/24.
//

import Foundation

class RetailBillingViewModel {
    
    public func calculateFullPayment(paymentData: [retailBillingDataModel]) -> Double {
        var value: Double = 0.0
        for i in paymentData {
            let summation = i.quantity * (Int(i.cost) ?? 0)
            value += Double(summation)
        }
        return value
    }
    
}
