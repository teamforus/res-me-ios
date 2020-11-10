//
//  ConfirmPaymentActionPopUp.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 06.08.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ConfirmPaymentActionPopUp: UIView {

    let backgroundView: Background_DarkMode = {
        let view = Background_DarkMode(frame: .zero)
        view.colorName = "Black_Light_DarkTheme"
        return view
    }()
    
    let bodyView: Background_DarkMode = {
        let view = CustomCornerUIView(frame: .zero)
        view.cornerRadius = 16
        return view
    }()
    
    let titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        return label
    }()
    
    let amountLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(frame: .zero)
        return button
    }()
    
    let confirmButton: ShadowButton = {
        let button = ShadowButton(frame: .zero)
        button.cornerRadius = 6
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

}

// MARK: - Init View

extension ConfirmPaymentActionPopUp {
    func initView() {
        addSubviews()
        addSubviewsForBody()
        addConstraints()
        addConstraintsForBody()
    }
}

// MARK: - Add Subviews

extension ConfirmPaymentActionPopUp {
    func addSubviews() {
        let views = [backgroundView, bodyView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
    
    func addSubviewsForBody() {
        let views = [titleLabel, amountLabel, cancelButton, confirmButton]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
}

 // MARK: - Add Constraints

extension ConfirmPaymentActionPopUp {
    func addConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            bodyView.heightAnchor.constraint(equalToConstant: 250),
            bodyView.widthAnchor.constraint(equalToConstant: 300),
            bodyView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            bodyView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        ])
    }
    
    func addConstraintsForBody() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.bodyView.topAnchor, constant: 26),
            titleLabel.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 53),
            titleLabel.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant: 53)
        ])
        
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 9),
            amountLabel.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 19),
            amountLabel.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant: 19)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: self.bodyView.bottomAnchor, constant: 19),
            cancelButton.leadingAnchor.constraint(equalTo: self.bodyView.leadingAnchor, constant: 19),
            cancelButton.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: self.bodyView.bottomAnchor, constant: 19),
            confirmButton.trailingAnchor.constraint(equalTo: self.bodyView.trailingAnchor, constant: -19),
            confirmButton.heightAnchor.constraint(equalToConstant: 46),
            confirmButton.leadingAnchor.constraint(equalTo: self.cancelButton.trailingAnchor, constant: 6)
        ])
    }
}
