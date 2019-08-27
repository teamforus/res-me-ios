//
//  RecordsTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTypeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var validationNumber: UILabel!
    @IBOutlet weak var validateText: UILabel!
    var record: Record! {
        didSet{
            
            if record.validations?.count != 0 {
                
                validateText.isHidden = false
                validationNumber.isHidden = false
                validationNumber.text = String(describing: record.validations!.count)
                
            }else {
                
                validateText.isHidden = true
                validationNumber.isHidden = true
                
            }
            
            cellTypeLabel.text = record.name ?? ""
            nameLabel.text = record.value
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
