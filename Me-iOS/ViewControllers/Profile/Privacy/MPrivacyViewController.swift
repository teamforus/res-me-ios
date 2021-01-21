//
//  MPrivacyViewController.swift
//  Me-iOS
//
//  Created by mac on 20.01.2021.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit
enum PrivacyType: Int, CaseIterable{
  
  case sourceOfInformation = 0
  case privacyPolicy = 1
  case privelege = 2
  case requestYourData = 3
  case requestToDelete = 4
  case feedbackText = 5
  case sendEmail = 6
  case readAboutPrivacy = 7
  case dataProtection = 8
  
}


class MPrivacyViewController: UIViewController {
  
  var tableView: UITableView = {
    let tableView = UITableView(frame: .zero)
    tableView.separatorStyle = .none
    return tableView
  }()
  
  var iconImageView: UIImageView = {
    let imageView = UIImageView(frame: .zero)
    imageView.image = R.image.fill1Copy()
    imageView.contentMode = .scaleToFill
    return imageView
  }()
  
  var appNameLabel: UILabel_DarkMode = {
    let label = UILabel_DarkMode(frame: .zero)
    label.text = "Me"
    label.font = R.font.googleSansBold(size: 17)
    return label
  }()
  
  var companyName: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "Forus, 2020"
    label.font = R.font.googleSansRegular(size: 14)
    label.textColor = #colorLiteral(red: 0.431086272, green: 0.4391285777, blue: 0.4474107623, alpha: 1)
    return label
  }()
  
  let closeBarButton: UIBarButtonItem = {
    let button = UIBarButtonItem(image: R.image.closeIcon(), style: .plain, target: self, action: #selector(dismiss(_:)))
    button.tintColor = .lightGray
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addSubviews()
    setupConstraints()
    setupView()
  }
  
  private func setupView() {
    if #available(iOS 11.0, *) {
      self.view.backgroundColor = UIColor(named: "WhiteBackground_DarkTheme")
    } else {
      self.view.backgroundColor = .white
    }
    setupTableView()
    setupNavigationBar()
  }
  
  private func setupTableView() {
    tableView.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.identifier)
    tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func setupNavigationBar() {
    if #available(iOS 11.0, *) {
      self.navigationController?.navigationBar.prefersLargeTitles = true
    } else {
    }
    self.navigationItem.rightBarButtonItem = closeBarButton
    self.title = "Privacy"
  }
}


extension MPrivacyViewController:UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return PrivacyType.allCases.count
  }

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let section = PrivacyType.allCases[indexPath.row]
  
  switch section {
  case .sourceOfInformation:
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else {
      return UITableViewCell()
    }
    
    cell.configureCellInfo(by: section)
    
    return cell
   
  case .privacyPolicy:
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as? ButtonTableViewCell else {
      return UITableViewCell()
    }
    cell.configureCellInfo(text: "Privacy Policy", by: section)
    return cell
  case .privelege:
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else {
      return UITableViewCell()
    }
    cell.configureCellInfo(by: section)
    return cell
  case .requestYourData:
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as? ButtonTableViewCell else {
      return UITableViewCell()
    }
    cell.configureCellInfo(text: "Request your data by email", by: section)
    
    return cell
  case .requestToDelete:
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as? ButtonTableViewCell else {
      return UITableViewCell()
    }
    cell.configureCellInfo(text: "Request to delete your data", by: section)
    return cell
  case .feedbackText:
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else {
      return UITableViewCell()
    }
    cell.configureCellInfo(by: section)
    
    return cell
  case .sendEmail:
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as? ButtonTableViewCell else {
      return UITableViewCell()
    }
    cell.configureCellInfo(text: "Send a mail to support@forus.io", by: section)
    return cell
  case .readAboutPrivacy:
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else {
      return UITableViewCell()
    }
    cell.configureCellInfo(by: section)
    return cell
  case .dataProtection:
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.identifier, for: indexPath) as? ButtonTableViewCell else {
      return UITableViewCell()
    }
    cell.configureCellInfo(text: "Data Protection Authority", by: section)
    return cell
  }

  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let section = PrivacyType.allCases[indexPath.row]
    switch section {
    case .privacyPolicy, .requestYourData, .requestToDelete, .sendEmail, .dataProtection:
      return 60
    default:
      return UITableView.automaticDimension
    }

  }

}

extension MPrivacyViewController {
  // MARK: - Add Subviews
  private func addSubviews() {
    let views = [tableView, iconImageView, appNameLabel, companyName]
    views.forEach { (view) in
      view.translatesAutoresizingMaskIntoConstraints = false
      self.view.addSubview(view)
    }
  }
}

extension MPrivacyViewController {
  // MARK: - Setup Constraints
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
    
    NSLayoutConstraint.activate([
      iconImageView.heightAnchor.constraint(equalToConstant: 34),
      iconImageView.widthAnchor.constraint(equalToConstant: 40),
      iconImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17),
      iconImageView.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 28)
    ])
    
    NSLayoutConstraint.activate([
      appNameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 17),
      appNameLabel.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 28),
      appNameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
    ])
    
    NSLayoutConstraint.activate([
      companyName.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 17),
      companyName.topAnchor.constraint(equalTo: self.appNameLabel.bottomAnchor, constant: 2),
      companyName.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
      companyName.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -42)
    ])
  }
}
