//
//  PassTableViewCell.swift
//  TestProject
//
//  Created by Tcacenco Daniel on 5/9/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    static let identifier = "TransactionTableViewCell"
    
    @IBOutlet weak var companyTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusTransfer: UILabel!
    @IBOutlet weak var imageTransfer: UIImageView!
    
    @IBOutlet weak var imageEarth: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(transaction: Transaction, isSubsidies: Bool) {
        if isSubsidies {
            self.statusTransfer.text = transaction.created_at?.dateFormaterNormalDate()
        }else {
            self.statusTransfer.text = transaction.product != nil ? Localize.product_voucher(): Localize.transaction()
        }
        self.companyTitle.text = transaction.product != nil ? transaction.product?.name : transaction.organization?.name ?? ""
        self.priceLabel.isHidden = isSubsidies
        if transaction.product != nil {
            
            self.imageTransfer.loadImageUsingUrlString(urlString: transaction.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            
        }else if transaction.organization != nil {
            
            self.imageTransfer.loadImageUsingUrlString(urlString: transaction.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
        }
        if let price = transaction.amount {
            self.priceLabel.text = "€ \(price.substringLeftPart()),\(price.substringRightPart())"
        }else {
            self.priceLabel.text = "€ 0,0"
        }
        self.dateLabel.text = isSubsidies ? transaction.organization?.name : transaction.created_at?.dateFormaterNormalDate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}



