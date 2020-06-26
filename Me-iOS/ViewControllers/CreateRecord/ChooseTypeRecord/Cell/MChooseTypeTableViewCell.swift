//
//  MAChooseTypeTableViewCell.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/25/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

protocol MChooseTypeTableViewCellDelegate: class {
    func chooseType(cell: MChooseTypeTableViewCell)
}

import UIKit
import UICheckbox_Swift

class MChooseTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var typeButton: ShadowButton!
    @IBOutlet weak var checkBox: UICheckbox!
    var isSelectedCell: Bool! = false
    @IBOutlet weak var titleRecordType: UILabel!
    weak var delegate: MChooseTypeTableViewCellDelegate!
    @IBOutlet weak var viewTypeRecord: CustomCornerUIView!
    var recordType: RecordType! {
        didSet{
            titleRecordType.text = recordType.name ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gestureRecognize = UITapGestureRecognizer(target:self, action: #selector(chooseTypeRecord))
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addGestureRecognizer(gestureRecognize)
    }
    
    @objc func chooseTypeRecord(){
        delegate.chooseType(cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
