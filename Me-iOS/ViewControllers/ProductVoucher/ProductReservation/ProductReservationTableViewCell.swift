//
//  ProductReservationTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 8/22/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ProductReservationTableViewCell: UITableViewCell {
    @IBOutlet weak var titleVoucher: UILabel!
    @IBOutlet weak var priceVoucher: UILabel!
    @IBOutlet weak var iconVoucher: RoundImageView!
    
    var productReservation: Transaction! {
        didSet{
            titleVoucher.text = productReservation.product?.name ?? ""
            priceVoucher.text = productReservation.product?.price ?? "0€"
            self.iconVoucher.loadImageUsingUrlString(urlString: productReservation?.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
