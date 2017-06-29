//
//  File.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 01/05/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import Foundation

class transactionModel{
    var extra:String!
    var transactionId: String
    var transactionAmt: Int
    var transactionTime: String
    var transactionDate: String
    
    init(extra:String,transactionId: String,transactionAmt: Int,transactionTime: String,transactionDate: String) {
        self.extra = ""
        self.transactionId = ""
        self.transactionAmt = 0
        self.transactionTime = ""
        self.transactionDate = ""
    }
}
