//
//  ConfirmPayAction.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 04.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ConfirmPayAction: UIView {
    
    var subsidie: Subsidie?
    var organization: AllowedOrganization?
    var address: String!
    
    var commonService: CommonServiceProtocol! = CommonService()
    var vc: UIViewController!
    
    private let blurView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.alpha = 0.3
        return view
    }()
    
    private let bodyView: CustomCornerUIView = {
        let view = CustomCornerUIView(frame: .zero)
        view.colorName = "WhiteBackground_DarkTheme"
        view.cornerRadius = 16
        return view
    }()
    
    private let titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Medium", size: 24)
        label.text = Localize.confirm_transaction()
        return label
    }()
    
    private let priceLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
     let cancelButton: ActionButton = {
        let button = ActionButton(frame: .zero)
        button.setTitle(Localize.cancel(), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1), for: .normal)
        return button
    }()
    
    private let confirmButton: ShadowButton = {
        let button = ShadowButton(frame: .zero)
        button.setTitle(Localize.confirm(), for: .normal)
        button.cornerRadius = 6
        button.backgroundColor = #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1)
        button.addTarget(self, action: #selector(confirmPay), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        addBodySubviews()
        setupBodyConstraints()
    }
    
    func setupView() {
        priceLabel.text = "Heeft de klant  betaald aan de kassa?"
        priceLabel.font = UIFont(name: "GoogleSans-Regular", size: 16)
        let mainString = String(format: "Heeft de klant\n" + "€ " + subsidie!.price_user! + "\nbetaald aan de kassa?")
        let range = (mainString as NSString).range(of: "€ " + subsidie!.price_user!)
        let attributedString = NSMutableAttributedString(string:mainString)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "GoogleSans-Regular", size: 40)! , range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1).cgColor, range: range)
        priceLabel.attributedText = attributedString
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

// MARK: - Add Subviews

extension ConfirmPayAction {
    
    func addSubviews() {
        let views = [blurView, bodyView]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
    
    func addBodySubviews() {
        let views = [titleLabel, priceLabel, cancelButton, confirmButton]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.bodyView.addSubview(view)
        }
    }
}

// MARK: - Add Constraints

extension ConfirmPayAction {
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bodyView.heightAnchor.constraint(equalToConstant: 250),
            bodyView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            bodyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 38),
            bodyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -38)
        ])
    }
    
    func setupBodyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 26),
            titleLabel.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 52),
            titleLabel.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: 52)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 9),
            priceLabel.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 0),
            priceLabel.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -19),
            cancelButton.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 19),
            cancelButton.heightAnchor.constraint(equalToConstant: 46),
            cancelButton.widthAnchor.constraint(equalToConstant: 128)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -19),
            confirmButton.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -19),
            confirmButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 6),
            confirmButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }
}

// MARK: - Request

extension ConfirmPayAction {
   @objc func confirmPay() {
    KVSpinnerView.show()
        let data = SubsidiePay(organization_id: organization?.id ?? 0, product_id: subsidie?.id ?? 0)
        commonService.create(request: "platform/provider/vouchers/" + address! + "/transactions", data: data) { (response: ResponseData<Transaction>, statusCode) in
            
            DispatchQueue.main.async {
                KVSpinnerView.dismiss()
                if statusCode == 201 {
                    
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.success(), message: Localize.payment_succeeded(), okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                        
                            self.vc.presentingViewController?.presentingViewController?.dismiss(animated: true)
                    }))
                }else if statusCode == 401 {
                    DispatchQueue.main.async {
                        KVSpinnerView.dismiss()
                        self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                            self.vc.logoutOptions()
                        }))
                    }
                }else {
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.warning(), message: Localize.voucher_not_have_enough_funds(), okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                    }))
                }
            }
        }
    }
}
