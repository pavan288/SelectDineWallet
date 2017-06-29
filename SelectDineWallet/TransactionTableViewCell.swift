//
//  TransactionTableViewCell.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 01/05/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet var extra: UILabel!
    @IBOutlet var transactionId: UILabel!
    @IBOutlet var transactionAmt: UILabel!
    @IBOutlet var transactionTime: UILabel!
    @IBOutlet var transactionDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
