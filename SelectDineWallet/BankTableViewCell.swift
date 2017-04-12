//
//  BankTableViewCell.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 11/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit

class BankTableViewCell: UITableViewCell {

    @IBOutlet var stateName: UILabel!
    @IBOutlet var bankName: UILabel!
    @IBOutlet var cityName: UILabel!
    @IBOutlet var branchName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
