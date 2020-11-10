//
//  MActionsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 06.08.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MActionsViewController: UIViewController {
    
    var voucherView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    let backButton: BackButton_DarkMode = {
        let button = BackButton_DarkMode()
        return button
    }()
    
    let titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        return label
    }()
    
    var voucherBodyIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    let voucherTitleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        return label
    }()
    
    let fundOrganizationNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        return label
    }()
    
    let voucherIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    let chooseActionTitle: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        return label
    }()
    
    let descriptionPaymentLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
}

 // MARK: - Init View

extension MActionsViewController {
    func initView() {
        addSubviews()
        addSubviewToVoucherBody()
        addConstraints()
        addConstraintsInVoucherBodyView()
    }
}

// MARK: - Add Subviews

extension MActionsViewController {
    func addSubviews() {
        let views = [voucherView, chooseActionTitle, descriptionPaymentLabel, tableView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
    }
    
    func addSubviewToVoucherBody() {
        let views = [backButton, titleLabel, voucherBodyIcon, voucherTitleLabel, fundOrganizationNameLabel, voucherIcon]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
    }
}

// MARK: - Add Constraints

extension MActionsViewController {
    func addConstraints() {
        NSLayoutConstraint.activate([
            voucherView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            voucherView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            voucherView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            voucherView.heightAnchor.constraint(equalToConstant: 241)
        ])
        
        NSLayoutConstraint.activate([
            chooseActionTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            chooseActionTitle.topAnchor.constraint(equalTo: self.voucherView.bottomAnchor, constant: 29)
        ])
        
        NSLayoutConstraint.activate([
            descriptionPaymentLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            descriptionPaymentLabel.topAnchor.constraint(equalTo: self.chooseActionTitle.topAnchor, constant: 6)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: descriptionPaymentLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
    }
    
    func addConstraintsInVoucherBodyView() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.voucherView.leadingAnchor, constant: 5),
            backButton.topAnchor.constraint(equalTo: self.voucherView.topAnchor, constant: 51),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: self.voucherView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.voucherView.trailingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            voucherBodyIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 21),
            voucherBodyIcon.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            voucherBodyIcon.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            voucherBodyIcon.bottomAnchor.constraint(equalTo: self.voucherView.bottomAnchor, constant: 22)
        ])
        
        NSLayoutConstraint.activate([
            voucherTitleLabel.topAnchor.constraint(equalTo: self.voucherBodyIcon.topAnchor, constant: 28),
            voucherTitleLabel.leadingAnchor.constraint(equalTo: self.voucherView.leadingAnchor, constant: 32),
        ])
        
        NSLayoutConstraint.activate([
            fundOrganizationNameLabel.topAnchor.constraint(equalTo: self.voucherTitleLabel.bottomAnchor, constant: 4),
            fundOrganizationNameLabel.leadingAnchor.constraint(equalTo: self.voucherView.leadingAnchor, constant: 32)
        ])
        
        NSLayoutConstraint.activate([
            voucherIcon.heightAnchor.constraint(equalToConstant: 70),
            voucherIcon.widthAnchor.constraint(equalToConstant: 70),
            voucherIcon.trailingAnchor.constraint(equalTo: self.voucherView.trailingAnchor, constant: -28),
            voucherIcon.centerYAnchor.constraint(equalTo: self.voucherView.centerYAnchor, constant: 0),
        ])
    }
}
