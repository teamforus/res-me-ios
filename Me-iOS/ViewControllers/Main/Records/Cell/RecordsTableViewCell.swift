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
    @IBOutlet weak var bodyView: CustomCornerUIView!
    var record: Record! {
        didSet{
            cellTypeLabel.text = record.name ?? ""
            nameLabel.text = record.value
           setupAccessibility(with: record.name ?? "", and: record.value ?? "")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.selectionStyle = .none
        if #available(iOS 11.0, *) {
            self.bodyView.layer.shadowColor = UIColor(named: "Black_Light_DarkTheme")?.cgColor
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 11.0, *) {
            self.bodyView.layer.shadowColor = UIColor(named: "Black_Light_DarkTheme")?.cgColor
        } else {
            // Fallback on earlier versions
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension RecordsTableViewCell {
  func setupAccessibility(with recordName: String, and recordValue: String) {
    self.bodyView.setupAccesibility(description: Localize.record() + recordName + recordValue, accessibilityTraits: .button)
  }
}
