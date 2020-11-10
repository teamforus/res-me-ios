//
//  PullUpQRViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 10/25/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

public enum QRType{
    case AuthToken
    case Voucher
    case Record
    case Profile
}

class PullUpQRViewController: UIViewController {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var voucherNameLabel: UILabel!
    @IBOutlet weak var dateExpireLabel: UILabel!
    @IBOutlet weak var bodyView: CustomCornerUIView!
    @IBOutlet weak var titleDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var timer : Timer! = Timer()
    var token: String!
    var idRecord: Int!
    var qrType: QRType! = QRType.Profile
    lazy var bottomQRViewModel: CommonBottomViewModel! = {
        return CommonBottomViewModel()
    }()
    var voucher: Voucher!
    var record: Record!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomQRViewModel.vc = self
        bodyView.roundCorners(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 9)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        setupAccessibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch qrType {
        case .AuthToken?:
            
            bottomQRViewModel.completeToken = { [weak self] (token, accessToken) in
                
                DispatchQueue.main.async {
                    
                    self?.qrImage.generateQRCode(from: "{ \"type\": \"auth_token\",\"value\": \"\(token)\", \"imgUrl\" : \"https://media.forus.io/assets/me-logo.png\" }")
                    self?.timer = Timer.scheduledTimer(timeInterval: 7, target: self!, selector: #selector(self?.checkAuthorizeToken), userInfo: nil, repeats: true)
                    self?.token = accessToken
                    
                }
            }
            
            bottomQRViewModel.initFetchQrToken()
            
            break
        case .Voucher?:
            
            self.titleDescriptionLabel.text = Localize.this_is_your_vouchers_qr_code()
            self.descriptionLabel.text = Localize.let_shopkeeper_scan_it_make_payment_from_your_voucher()
            
            self.qrImage.generateQRCode(from: "{ \"type\": \"voucher\",\"value\": \"\(self.voucher.address ?? "")\", \"imgUrl\" : \"https://media.forus.io/assets/me-logo.png\" }")
            
            if voucher.product != nil {
                
                voucherNameLabel.text = voucher.product?.name ?? ""
                
            }else {
                
                voucherNameLabel.text = voucher.fund?.name ?? ""
                
            }
            
            dateExpireLabel.text = Localize.this_voucher_is_expired_on((voucher.expire_at?.date?.dateFormaterExpireDate())!)
            
            break
        case .Record?:
            self.voucherNameLabel.isHidden = true
            self.dateExpireLabel.isHidden = true
            self.titleDescriptionLabel.text = Localize.this_is_your_vouchers_qr_code()
            if let name = self.record.name {
                self.descriptionLabel.text = Localize.let_shopkeeper_scan_it_to_make_validtion_to_your_record(name)
            }
            
            
            bottomQRViewModel.completeRecord = { [weak self] (record) in
                
                DispatchQueue.main.async {
                    UserDefaults.standard.set(record.uuid ?? "", forKey: UserDefaultsName.CurrentRecordUUID)
                    self?.qrImage.generateQRCode(from: "{ \"type\": \"record\",\"value\": \"\(record.uuid ?? "")\", \"imgUrl\" : \"https://media.forus.io/assets/me-logo.png\" }")
                    
                }
            }
            
            bottomQRViewModel.initFetchRecordToken(idRecords: idRecord)
            
            break
        case .Profile?:
            bottomQRViewModel.completeIdentity = { [weak self] (identityAddress) in
                
                DispatchQueue.main.async {
                    
                    self?.qrImage.generateQRCode(from: "{ \"type\": \"identity\",\"value\": \"\(identityAddress)\", \"imgUrl\" : \"https://media.forus.io/assets/me-logo.png\" }")
                    
                }
            }
            bottomQRViewModel.getIndentity()
            
            break
        default:
            break
        }
    }
    
    @objc func checkAuthorizeToken(){
        
        bottomQRViewModel.completeAuthorize = { [weak self] (message) in
            
            DispatchQueue.main.async {
                if message == "active"{
                    self?.timer.invalidate()
                    self?.saveNewIdentity(accessToken: self!.token)
                    UserDefaults.standard.set(self?.getCurrentUser().accessToken!, forKey: UserDefaultsName.Token)
                    UserDefaults.standard.set(true, forKey: UserDefaultsName.UserIsLoged)
                    CurrentSession.shared.token = self?.token
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: NotificationName.LoginQR, object: nil)
                }
            }
            
        }
        bottomQRViewModel.initAuthorizeToken(token: token)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    @IBAction func closeQR(_ sender: Any) {
        closeQRAction()
    }
    
    @IBAction func closeGesture(_ sender: Any) {
        closeQRAction()
    }
    
    func closeQRAction(){
        self.bottomConstraint.constant = 439
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (isFinished) in
            self.view.removeFromSuperview()
        })
    }
    
}

// MARK: - Accessibility Protocol

extension PullUpQRViewController: AccessibilityProtocol {
    func setupAccessibility() {
        qrImage.setupAccesibility(description: "QR Code", accessibilityTraits: .image)
        closeButton.setupAccesibility(description: "Close", accessibilityTraits: .button)
    }
}
