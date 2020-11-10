//
//  OrganizationValidatorTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 10/21/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class OrganizationValidatorTableViewCell: UITableViewCell {
    @IBOutlet weak var imageOrganization: UILabel!
    @IBOutlet weak var organizationName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
      if #available(iOS 11.0, *) {
        self.backgroundColor = UIColor(named: "")
      } else {
        // Fallback on earlier versions
      }
    }
    
    func setupRecordOrganization(organization: EmployeesOrganization) {
        self.organizationName.text = organization.organization?.name ?? ""
    }
    
    func setupVoucherOrganization(organization: AllowedOrganization) {
        self.organizationName.text = organization.name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
