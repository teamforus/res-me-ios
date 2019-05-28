//
//  MAWaletVoucherTableViewCell.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 8/3/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

class VoucherTableViewCell: UITableViewCell {
    @IBOutlet weak var voucherTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var voucherImage: RoundImageView!
    @IBOutlet weak var organizationNameLabel: UILabel!
    @IBOutlet weak var usedVoucherLabel: UILabel!
    var voucher: Voucher? {
        didSet{
            self.voucherTitleLabel.text = voucher?.product != nil ? voucher?.product?.name : voucher?.fund?.name
            self.organizationNameLabel.text = voucher?.fund?.organization?.name ?? ""
            if voucher?.product != nil{
                
                self.priceLabel.isHidden = true
    
                self.voucherImage.loadImageUsingUrlString(urlString: voucher?.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            }else{
                self.priceLabel.isHidden = false
                
                if let price = voucher?.amount {
                    self.priceLabel.attributedText = "€ \(price.substringLeftPart()).{\(price.substringRightPart())}".customText(fontBigSize: 20, minFontSize: 14)
                }else {
                    self.priceLabel.attributedText = "0.{0}".customText(fontBigSize: 20, minFontSize: 14)
                }
                
                self.voucherImage.loadImageUsingUrlString(urlString: voucher?.fund?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            }
            
            
//            if voucher?.product?.photo != nil || voucher?.found.logo != nil {
//                self.voucherImage.sd_setImage(with: URL(string: (voucher?.product != nil ? voucher?.product?.photo?.sizes?.thumbnail : voucher?.found.logo.sizes?.thumbnail) ?? ""), placeholderImage: UIImage(named: "Resting"))
//
//            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.usedVoucherLabel.isHidden = true
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}