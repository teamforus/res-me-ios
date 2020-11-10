//
//  MPaymentViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class MPaymentViewController: UIViewController {
    @IBOutlet weak var voucherNameLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var voucherIcon: CornerImageView!
    @IBOutlet weak var organizationIcon: UIImageView!
    @IBOutlet weak var allowedOriganizationLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var notesView: CustomCornerUIView!
    @IBOutlet weak var chooseOrganizationButton: UIButton!
    @IBOutlet weak var heightFieldsConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var priceUILabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var isFromReservation: Bool!
    var testToken: String!
    var voucher: Voucher!
    var tabBar: UITabBarController!
    var selectedAllowerdOrganization: AllowedOrganization!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        if voucher != nil {
            initView()
        }else {
            titleLabel.text = Localize.test_transaction()
            allowedOriganizationLabel.text = Localize.test_organization()
            organizationLabel.isHidden = true
            priceUILabel.isHidden = true
        }
        
    }
    
    
    @IBAction func send(_ sender: Any) {
        var limitEN = "0.01"
        var limitDT = "0,01"
        
        //        if voucher.fund?.currency == "eth" {
        //            limitEN = "0.0001"
        //            limitDT = "0,0001"
        //        }
        
        if voucher != nil {
            
            if voucher.product != nil {
                
                let vc = ConfirmPaymentPopUp()
                if isFromReservation != nil {
                    vc.isFromReservation = isFromReservation
                }
                vc.voucher = voucher
                vc.organizationId = selectedAllowerdOrganization?.id ?? 0
                vc.note = notesField.text
                vc.amount = amountField.text
                vc.tabBar = tabBar
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
                
            }else if amountField.text != "" {
                
                if amountField.text != limitEN && amountField.text != limitDT{
                    
                    let vc = ConfirmPaymentPopUp()
                    if isFromReservation != nil {
                        vc.isFromReservation = isFromReservation
                    }
                    vc.voucher = voucher
                    vc.organizationId = selectedAllowerdOrganization?.id ?? 0
                    vc.note = notesField.text
                    vc.amount = amountField.text
                    vc.tabBar = tabBar
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true)
                }else {
                    
                    showSimpleAlert(title: Localize.warning(), message: Localize.payment_of_001_is_to_low_to_be_paid_out_choose_highe_amount())
                    
                }
                
            } else {
                
                showSimpleAlert(title: Localize.warning(), message: Localize.please_enter_the_amount())
                
            }
            
        }else {
            let vc = ConfirmPaymentPopUp()
            if isFromReservation != nil {
                vc.isFromReservation = isFromReservation
            }
            vc.organizationId = 0
            vc.testToken = testToken
            vc.note = notesField.text
            vc.amount = amountField.text
            vc.tabBar = tabBar
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
        }
    }
    
    
    
    
}

extension MPaymentViewController {
    
    func initView(){
        if #available(iOS 13, *) {
        }else {
            self.setStatusBarStyle(.default)
        }
        if voucher?.product != nil {
            if let price = voucher?.product?.price {
                priceUILabel.text = "€ " + price
            }
            arrowIcon.isHidden = true
            chooseOrganizationButton.isHidden = true
            voucherNameLabel.text = voucher.product?.name ?? ""
            voucherIcon.loadImageUsingUrlString(urlString: voucher.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            organizationLabel.text = voucher.product?.organization?.name ?? ""
            allowedOriganizationLabel.text = voucher.product?.organization?.name ?? ""
            organizationIcon.loadImageUsingUrlString(urlString: voucher.product?.photo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            
            var rectNote = self.notesView.frame
            rectNote.origin.y = 70
            self.notesView.frame = rectNote
            heightFieldsConstraint.constant = 160
            
        }else {
            if let price = voucher?.amount {
                priceUILabel.text = "€ " + price
            }
            voucherNameLabel.text = voucher.fund?.name ?? ""
            voucherIcon.loadImageUsingUrlString(urlString: voucher.fund?.organization?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            organizationLabel.text = voucher.fund?.organization?.name ?? ""
            allowedOriganizationLabel.text = voucher.allowed_organizations?.first?.name ?? ""
            organizationIcon.loadImageUsingUrlString(urlString: voucher.allowed_organizations?.first?.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
            selectedAllowerdOrganization = voucher.allowed_organizations?.first
        }
        amountField.setPlaceholderColor(with: Localize.enter_the_price_here(), and: .lightGray)
        notesField.setPlaceholderColor(with: Localize.note(), and: .lightGray)
       let image = UIImage(named: "roundedRight")?.withRenderingMode(.alwaysTemplate)
        self.arrowIcon.image = image
        if #available(iOS 11.0, *) {
            self.arrowIcon.tintColor = UIColor(named: "Black_Light_DarkTheme")
        } else {
          // Fallback on earlier versions
        }
    }
    
    @IBAction func showOrganizations(_ sender: UIButton) {
        if voucher != nil {
            let popOverVC = AllowedOrganizationsViewController(nibName: "AllowedOrganizationsViewController", bundle: nil)
            popOverVC.allowedOrganizations = self.voucher.allowed_organizations!
            popOverVC.delegate = self
            popOverVC.selectedOrganizations = selectedAllowerdOrganization
            self.addChild(popOverVC)
            popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(popOverVC.view)
        }
    }
    
    
    
}

extension MPaymentViewController: AllowedOrganizationsViewControllerDelegate {
    func didSelectEmployeeOrganization(organization: EmployeesOrganization) {
        
    }
    
    func didSelectAllowedOrganization(organization: AllowedOrganization) {
        
        selectedAllowerdOrganization = organization
        allowedOriganizationLabel.text = organization.name ?? ""
        organizationIcon.loadImageUsingUrlString(urlString: organization.logo?.sizes?.thumbnail ?? "", placeHolder: #imageLiteral(resourceName: "Resting"))
        
    }
    
}

extension MPaymentViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var dotString = ""
        var limitAfterDot = 2
        if self.getLanguageISO() == "en"{
            
            dotString = "."
            
        }else if self.getLanguageISO() == "nl" {
            
            dotString = ","
        }
        
        if let text = textField.text {
            let isDeleteKey = string.isEmpty
            
            if !isDeleteKey {
                if text.contains(dotString) {
                    let countdots = textField.text!.components(separatedBy: dotString).count - 1
                    
                    if countdots > 0 && string == dotString
                    {
                        return false
                    }
                    if voucher.fund?.currency == "eth" {
                        limitAfterDot = 4
                    }
                    if text.components(separatedBy: dotString)[1].count == limitAfterDot {
                        
                        return false
                    }
                }
            }
        }
        return true
    }
    
}
extension MPaymentViewController: AccessibilityProtocol {
    func setupAccessibility() {
     // sendEmailButton.chooseOrganizationButton(description: "Choose Organization Button", accessibilityTraits: .button)
       
   }
}
