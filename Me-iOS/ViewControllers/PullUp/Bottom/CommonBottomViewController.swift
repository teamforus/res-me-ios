//
//  MLoginBottomViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ISHPullUp

public enum QRType{
    case AuthToken
    case Voucher
    case Record
    case Profile
}

class CommonBottomViewController: UIViewController {
    
    @IBOutlet private weak var handleView: ISHPullUpHandleView!
    @IBOutlet private weak var rootView: UIView!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var voucherName: UILabel!
    @IBOutlet weak var expiredLabel: UILabel!
    @IBOutlet weak var titleQrLabel: UILabel!
    
    
    var timer : Timer! = Timer()
    private var firstAppearanceCompleted = false
    var token: String!
    var idRecord: Int!
    weak var pullUpController: ISHPullUpViewController!
    private var halfWayPoint = CGFloat(0)
    var qrType: QRType! = QRType.Profile
    lazy var bottomQRViewModel: CommonBottomViewModel! = {
        return CommonBottomViewModel()
    }()
    var voucher: Voucher!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if qrType == .Profile {
            handleView.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(toglePullUpView), name: NotificationName.TogleStateWindow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(toglePullUpView), name: NotificationName.TogleStateWindowFormProduct, object: nil)
        
        switch qrType {
        case .AuthToken?:
            
            bottomQRViewModel.completeToken = { [weak self] (token, accessToken) in
                
                DispatchQueue.main.async {
                    
                    self?.qrCodeImageView.generateQRCode(from: "{ \"type\": \"auth_token\",\"value\": \"\(token)\" }")
                    self?.timer = Timer.scheduledTimer(timeInterval: 7, target: self!, selector: #selector(self?.checkAuthorizeToken), userInfo: nil, repeats: true)
                    self?.token = accessToken
                    
                }
            }
            
            bottomQRViewModel.initFetchQrToken()
            
            break
        case .Voucher?:
            
            self.qrCodeImageView.generateQRCode(from: "{ \"type\": \"voucher\",\"value\": \"\(self.voucher.address ?? "")\" }")
            
            if voucher.product != nil {
                
                titleQrLabel.text = voucher.product?.name ?? ""
                
            }else {
                
                titleQrLabel.text = voucher.fund?.name ?? ""
                
            }
            
            expiredLabel.text = "This voucher expires on ".localized() + (voucher.expire_at?.date?.dateFormaterExpireDate())!
            
            break
        case .Record?:
            
            bottomQRViewModel.completeRecord = { [weak self] (record) in
                
                DispatchQueue.main.async {
                    
                    self?.qrCodeImageView.generateQRCode(from: "{ \"type\": \"record\",\"value\": \"\(record.uuid ?? "")\" }")
                    
                }
            }
            
            bottomQRViewModel.initFetchRecordToken(idRecords: idRecord)
            
            break
        case .Profile?:
            bottomQRViewModel.completeIdentity = { [weak self] (identityAddress) in
                
                DispatchQueue.main.async {
                    
                    self?.qrCodeImageView.generateQRCode(from: "{ \"type\": \"identity\",\"value\": \"\(identityAddress)\" }")
                    
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
                    UserDefaults.standard.set(self?.token, forKey: UserDefaultsName.Token)
                    UserDefaults.standard.set(true, forKey: UserDefaultsName.UserIsLoged)
                    CurrentSession.shared.token = self?.token
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: NotificationName.LoginQR, object: nil)
                }
            }
            
        }
        bottomQRViewModel.initAuthorizeToken(token: token)
        
    }
    
    @objc func toglePullUpView(){
        if pullUpController?.state == .expanded{
            if #available(iOS 13, *) {
            }else {
                self.setStatusBarStyle(.default)
            }
            if qrType != .Profile {
                self.view.isHidden = true
            }
        }else{
            if #available(iOS 13, *) {
            }else {
                self.setStatusBarStyle(.lightContent)
            }
            if qrType != .Profile {
                self.view.isHidden = false
            }
        }
        pullUpController?.toggleState(animated: true)
    }
    
    @IBAction func close(_ sender: Any) {
        if pullUpController.state == .expanded || pullUpController.state == .intermediate{
            pullUpController.toggleState(animated: true)
            if #available(iOS 13, *) {
            }else {
                self.setStatusBarStyle(.default)
            }
            if qrType != .Profile {
                self.view.isHidden = true
            }
        }
    }
    
}

extension CommonBottomViewController: ISHPullUpStateDelegate, ISHPullUpSizingDelegate{
    
    // MARK: ISHPullUpSizingDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, maximumHeightForBottomViewController bottomVC: UIViewController, maximumAvailableHeight: CGFloat) -> CGFloat {
        let totalHeight = rootView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        halfWayPoint = totalHeight / 2.0
        return totalHeight
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, minimumHeightForBottomViewController bottomVC: UIViewController) -> CGFloat {
        return topView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height;
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, targetHeightForBottomViewController bottomVC: UIViewController, fromCurrentHeight height: CGFloat) -> CGFloat {
        if abs(height - halfWayPoint) < 30 {
            return halfWayPoint
        }
        return height
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forBottomViewController bottomVC: UIViewController) {
    }
    
    // MARK: ISHPullUpStateDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, didChangeTo state: ISHPullUpState) {
        handleView.setState(ISHPullUpHandleView.handleState(for: state), animated: firstAppearanceCompleted)
        if state == .collapsed {
            if qrType != .Profile {
                self.view.isHidden = true
            }
            if #available(iOS 13, *) {
            }else {
                self.setStatusBarStyle(.default)
            }
        }else if state == .intermediate {
            pullUpController.toggleState(animated: true)
        }
    }
    
}
