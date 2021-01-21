//
//  ButtonTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 20.01.2021.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
  static let identifier = "ButtonTableViewCell"
  
  // MARK: - Parameters
  
  var button: ShadowButton = {
    let button = ShadowButton(frame: .zero)
    button.titleLabel?.font = R.font.googleSansRegular(size: 14)
    button.setTitleColor(#colorLiteral(red: 0.1918309331, green: 0.3696506619, blue: 0.9919955134, alpha: 1), for: .normal)
    button.rounded(cornerRadius: 6)
    button.backgroundColor = #colorLiteral(red: 0.9449954033, green: 0.9451572299, blue: 0.9449852109, alpha: 1)
    return button
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
  
  func configureCellInfo(text: String, by type: PrivacyType) {
    button.setTitle(text, for: .normal)
  }
}

extension ButtonTableViewCell {
  // MARK: - Add Subviews
  private func addSubviews() {
    button.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(button)
  }
}

extension ButtonTableViewCell {
  // MARK: - Setup Constraints
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
      button.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 17),
      button.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -17),
      button.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
    ])
  }
}
