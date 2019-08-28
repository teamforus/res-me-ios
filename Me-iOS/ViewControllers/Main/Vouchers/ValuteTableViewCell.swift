//
//  ValuteTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 8/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ValuteTableViewCell: UITableViewCell {
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var vraagButton: UIButton!
    @IBOutlet weak var balanceEth: UILabel!
    
    var wallet: Wallet! {
        didSet{
            balanceEth.text = wallet.balance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
