//
//  ActionTableViewCell.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 04.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {
    
    static let identifier = "ActionTableViewCell"
    
    private let bodyView: CustomCornerUIView = {
        let view = CustomCornerUIView()
        view.cornerRadius = 12
        view.shadowRadius = 10
        view.shadowOpacity = 0.1
        view.colorName = "Gray_Dark_DarkTheme"
        return view
    }()
    
    private let subsidieNameLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.font = UIFont(name: "GoogleSans-Medium", size: 20)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GoogleSans-Regular", size: 20)
        label.textColor = #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1)
        return label
    }()
    
    private let subsidieImageView: UIImageView = {
        let imageview = UIImageView()
        return imageview
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: ActionTableViewCell.identifier)
        selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        addSubview()
        setupConstraint()
        addBodySubviews()
        setupBodyConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupActions(subsidie: Subsidie) {
        self.subsidieNameLabel.text = subsidie.name ?? ""
        self.priceLabel.text = subsidie.price_user ?? ""
        self.subsidieImageView.loadImageUsingUrlString(urlString:subsidie.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
    }
}

// MARK: - Add Subviews

extension ActionTableViewCell {
    
    func addSubview() {
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(bodyView)
    }
    
    func addBodySubviews() {
        let views = [subsidieNameLabel, priceLabel, subsidieImageView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.bodyView.addSubview(view)
        }
    }
}

// MARK: - Add Constraints

extension ActionTableViewCell {
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            bodyView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 17),
            bodyView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -17),
            bodyView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ])
    }
    
    func setupBodyConstraints() {
        NSLayoutConstraint.activate([
            subsidieNameLabel.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 20),
            subsidieNameLabel.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: subsidieNameLabel.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            subsidieImageView.centerYAnchor.constraint(equalTo: bodyView.centerYAnchor),
            subsidieImageView.heightAnchor.constraint(equalToConstant: 50),
            subsidieImageView.widthAnchor.constraint(equalToConstant: 50),
            subsidieImageView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -20),
            subsidieImageView.leadingAnchor.constraint(equalTo: subsidieNameLabel.trailingAnchor, constant: 20)
        ])
    }
}
