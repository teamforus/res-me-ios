//
//  TransactionListTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 16.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class TransactionListTableViewCell: UITableViewCell {
    
    static let identifier = "TransactionListTableViewCell"
    
    // MARK: - Properties
    private let bodyView: CustomCornerUIView = {
        let view = CustomCornerUIView(frame: .zero)
        view.shadowOffset = CGSize(width: 0, height: 0)
        view.shadowRadius = 10
        view.shadowOpacity = 0.1
        view.colorName = "Gray_Dark_DarkTheme"
        view.cornerRadius = 8
        return view
    }()
    
    private let organizationIcon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.corner = 12
        return imageView
    }()
    
    private let organizationNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 18)
        return label
    }()
    
    private let transactionDateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.5150660276, green: 0.5296565294, blue: 0.5467811227, alpha: 1)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Medium", size: 18)
        label.textAlignment = .right
        label.textColor = #colorLiteral(red: 0.1863445938, green: 0.365368098, blue: 0.9889068007, alpha: 1)
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.5150660276, green: 0.5296565294, blue: 0.5467811227, alpha: 1)
        label.textAlignment = .right
        return label
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        addSubiews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubiews()
        setupConstraints()
    }
    
    func configure(transaction: Transaction) {
        self.statusLabel.text = transaction.state
        self.organizationNameLabel.text = transaction.product != nil ? transaction.product?.name : transaction.organization?.name ?? ""
        
        if transaction.product != nil {
            
            self.organizationIcon.loadImageUsingUrlString(urlString: transaction.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            
        }else if transaction.organization != nil {
            
            self.organizationIcon.loadImageUsingUrlString(urlString: transaction.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
        }
        
        if let price = transaction.amount {
            self.priceLabel.text = "+ € \(price)"
        }else {
            self.priceLabel.text = "+ € 0"
        }
        self.transactionDateLabel.text = transaction.created_at?.dateFormaterNormalDate()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        organizationIcon.image = nil
        organizationNameLabel.text = nil
        transactionDateLabel.text = nil
        priceLabel.text = nil
        statusLabel.text = nil
        
    }
}


// MARK: - Add Subviews
extension TransactionListTableViewCell {
    private func addSubiews() {
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(bodyView)
        let views = [organizationIcon, organizationNameLabel, transactionDateLabel, priceLabel, statusLabel]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.bodyView.addSubview(view)
        }
    }
}

// MARK: - Setup Constraints
extension TransactionListTableViewCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bodyView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            bodyView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            bodyView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            bodyView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            organizationIcon.centerYAnchor.constraint(equalTo: bodyView.centerYAnchor, constant: 0),
            organizationIcon.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 15),
            organizationIcon.heightAnchor.constraint(equalToConstant: 24),
            organizationIcon.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            organizationNameLabel.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 19),
            organizationNameLabel.leadingAnchor.constraint(equalTo: organizationIcon.trailingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            transactionDateLabel.topAnchor.constraint(equalTo: organizationNameLabel.bottomAnchor, constant: 2),
            transactionDateLabel.leadingAnchor.constraint(equalTo: organizationIcon.trailingAnchor, constant: 16),
            transactionDateLabel.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -17)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -21),
            priceLabel.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 19),
            priceLabel.leadingAnchor.constraint(equalTo: organizationNameLabel.trailingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            statusLabel.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -21),
            statusLabel.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -17)
        ])
    }
}
