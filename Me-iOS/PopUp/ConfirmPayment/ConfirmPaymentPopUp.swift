//
//  ConfirmPaymentPopUp.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 6/4/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ConfirmPaymentPopUp: UIViewController {
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var insuficientLabel: UILabel!
    @IBOutlet weak var bodyView: CustomCornerUIView!
    @IBOutlet weak var declineButton: ShadowButton!
    @IBOutlet weak var confirmButton: ShadowButton!
    
    
    var voucher: Voucher!
    var voucherToken: Transaction!
    var testToken: String!
    var amount: String!
    var tabBar: UITabBarController!
    var organizationId: Int!
    var note: String!
    var commonService: CommonServiceProtocol! = CommonService()
    var isFromReservation: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAccessibility()
        if voucher != nil {
            initView()
        }else {
            paymentLabel.text = Localize.please_confirm_the_transaction(amount)
            self.didChangeHeightView()
        }
    }
    
    private func initView() {
        
        if voucher.product != nil {
            
            paymentLabel.text = Localize.please_confirm_the_transaction(voucher.product?.price ?? "0.00")
            amount = voucher.product?.price
            self.didChangeHeightView()
            organizationId = voucher.product?.organization?.id
            
        }else {
            
            let amountVoucher = Double(voucher.amount ?? "0.00")!
            let aditionalAmount = Double(amount.replacingOccurrences(of: ",", with: "."))! - amountVoucher
            
            paymentLabel.text = Localize.please_confirm_the_transaction(amount)
            
            
            if Double(amount!.replacingOccurrences(of: ",", with: "."))! > amountVoucher {
                //                if voucher.fund?.currency == "eur" {
                insuficientLabel.text = Localize.insufficient_funds_on_the_voucher_please_request_extra_payment(aditionalAmount)
                //                }else {
                //                insuficientLabel.text = String(format: NSLocalizedString("Insufficient funds on the voucher. Please, request extra payment of ETH%.02f", comment: ""), aditionalAmount)
                //                }
                
            }else{
                
                self.didChangeHeightView()
                
            }
        }
    }
    
    
    @IBAction func confirm(_ sender: UIButton) {
        sender.isEnabled = false
        if isReachable() {
            
            KVSpinnerView.show()
            
            if voucher != nil {
                let payTransaction = PayTransaction(organization_id: organizationId ?? 0, amount: amount.replacingOccurrences(of: ",", with: "."), note: note ?? "")
                
                commonService.create(request: "platform/vouchers/"+voucher.address!+"/transactions", data: payTransaction) { (response: ResponseData<Transaction>, statusCode) in
                    
                    DispatchQueue.main.async {
                        KVSpinnerView.dismiss()
                        if statusCode == 201 {
                            
                            self.showSimpleAlertWithSingleAction(title: Localize.success(), message: Localize.payment_succeeded(), okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                                
                                self.tabBar.selectedIndex = 0
                                if self.isFromReservation != nil {
                                    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true)
                                }else {
                                    self.presentingViewController?.presentingViewController?.dismiss(animated: true)
                                }
                            }))
                        }else if statusCode == 401 {
                            DispatchQueue.main.async {
                                KVSpinnerView.dismiss()
                                self.showSimpleAlertWithSingleAction(title: Localize.expired_session() , message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                                    self.logoutOptions()
                                }))
                            }
                        }else {
                            sender.isEnabled = true
                            self.showSimpleAlertWithSingleAction(title: Localize.warning(), message: Localize.voucher_not_have_enough_funds(), okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                                
                                
                            }))
                        }
                    }
                }
            }else {
                
                commonService.patchWithoutParam(request: "platform/demo/transactions/" + testToken) { ( statusCode) in
                    DispatchQueue.main.async {
                        if statusCode == 200 {
                            KVSpinnerView.dismiss()
                            self.showSimpleAlertWithSingleAction(title: Localize.success(), message: Localize.payment_succeeded(), okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                                
                                self.tabBar.selectedIndex = 0
                                if self.isFromReservation != nil {
                                    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true)
                                }else {
                                    self.presentingViewController?.presentingViewController?.dismiss(animated: true)
                                }
                            }))
                        }else if statusCode == 401 {
                            DispatchQueue.main.async {
                                KVSpinnerView.dismiss()
                                self.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                                    self.logoutOptions()
                                }))
                            }
                        }else {
                            KVSpinnerView.dismiss()
                            self.showSimpleAlertWithSingleAction(title: Localize.error_exclamation(), message: "This token is not valid!", okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                                
                            }))
                        }
                    }
                }
                
            }
        }else {
            sender.isEnabled = true
            showInternetUnable()
            
        }
    }
    
    func dismissModalStack(viewController: UIViewController, animated: Bool) {
        if viewController.presentingViewController != nil {
            var vc = viewController.presentingViewController!
            while (vc.presentingViewController != nil) {
                vc = vc.presentingViewController!;
            }
            vc.dismiss(animated: true)
            
            
        }
    }
    
}

// MARK: - Accessibility Protocol

extension ConfirmPaymentPopUp: AccessibilityProtocol {
    func setupAccessibility() {
        declineButton.setupAccesibility(description: Localize.decline(), accessibilityTraits: .button)
        confirmButton.setupAccesibility(description: Localize.confirm(), accessibilityTraits: .button)
    }
}

extension ConfirmPaymentPopUp {
    
    func didChangeHeightView(){
        var reactBodyView = bodyView.frame
        reactBodyView.size.height = reactBodyView.size.height - 36
        bodyView.frame = reactBodyView
        insuficientLabel.isHidden = true
    }
    
}
