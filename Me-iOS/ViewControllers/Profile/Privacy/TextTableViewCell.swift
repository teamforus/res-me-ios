//
//  TextTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 20.01.2021.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {
  static let identifier = "TextTableViewCell"
  
  // MARK: - Parameters
  
  var informationLabel: UILabel_DarkMode = {
    let label = UILabel_DarkMode(frame: .zero)
    label.font = R.font.googleSansRegular(size: 16)
    label.numberOfLines = 0
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    addSubviews()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCellInfo(by type: PrivacyType) {
    switch type {
    case .sourceOfInformation:
      setupSourceOfInformation()
    case .privelege:
      setupPrivileges()
    case .feedbackText:
      setupFeedbackText()
    case .readAboutPrivacy:
      setupReadAboutPrivacy()
    default:
      break
    }
  }
}

extension TextTableViewCell {
  // MARK: - Setup Text
  private func setupSourceOfInformation() {
    let mainString = String(format: "Manage your personal properties and share easily the information needed to qualify for a subsidy.\n\nThe source of information\n\nThe information has been added by an organisation where you have applied for a subsidy, or by an organisation that supports it. For example, By Your congregation. \n\nStoring data \n\nWe are store all your data that exist in your account, namely: \n\n• Subsidies and vouchers\n• Transactions\n• Personal info as records\n• Email\n• etc.\n\nPrivacy\n\nAll information is stored carefully and is not used for commercial purposes. Find out more about the Privacy Policy of Foundation Forus")
    let firstRange = (mainString as NSString).range(of: "The source of information")
    let secondRange = (mainString as NSString).range(of: "Storing data")
    let theredRange = (mainString as NSString).range(of: "Privacy")
    
    let attributedString = NSMutableAttributedString(string:mainString)
    attributedString.addAttribute(NSAttributedString.Key.font, value: R.font.googleSansMedium(size: 17) as Any , range: firstRange)
    attributedString.addAttribute(NSAttributedString.Key.font, value: R.font.googleSansMedium(size: 17) as Any , range: secondRange)
    attributedString.addAttribute(NSAttributedString.Key.font, value: R.font.googleSansMedium(size: 17) as Any , range: theredRange)
    informationLabel.attributedText = attributedString
  }
  
  private func setupPrivileges() {
    let mainString = "Privileges\n\nThe information is stored under European privacy legislation. This gives you some rights like the right to:\n\n• Information\n• Inspect\n• Rectification\n• Oblivion\n• Data portability\n• Objection\n• Limitation of processing"
    let range = (mainString as NSString).range(of: "Privileges")
    
    let attributedString = NSMutableAttributedString(string:mainString)
    attributedString.addAttribute(NSAttributedString.Key.font, value: R.font.googleSansMedium(size: 17) as Any , range: range)
    informationLabel.attributedText = attributedString
  }
  
  private func setupFeedbackText() {
    informationLabel.text = "If you want to claim your rights or you have general questions or feedback please do reach our support"
  }
  
  private func setupReadAboutPrivacy() {
    informationLabel.text = "Read all about your privacy rights with the Dutch Data Protection Authority "
  }
}

extension TextTableViewCell {
  // MARK: - Add Subviews
  private func addSubviews() {
    informationLabel.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(informationLabel)
  }
}

extension TextTableViewCell {
  // MARK: - Setup Constraints
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      informationLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
      informationLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 17),
      informationLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -17),
      informationLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
    ])
  }
}
