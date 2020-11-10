//
//  BottomQrWithPinViewController.swift
//  Me-iOS
//
//  Created by Daniel Tcacenco on 3/2/20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class BottomQrWithPinViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var qrCode: UIImageView!
    @IBOutlet weak var bodyView: CustomCornerUIView!
    @IBOutlet weak var pinCodeView: CustomCornerUIView!
    @IBOutlet weak var closeButton: UIButton!
    
    lazy var loginQrViewModel: LoginQrAndCodeViewModel = {
        return LoginQrAndCodeViewModel()
    }()
    
    lazy var bottomQRViewModel: CommonBottomViewModel! = {
        return CommonBottomViewModel()
    }()
    var timer: Timer! = Timer()
    var timerQR: Timer! = Timer()
    var token: String!
    var tokenQr: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAccessibility()
        bottomQRViewModel.vc = self
        bodyView.roundCorners(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 9)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isReachable() {
            
            loginQrViewModel.initFetchPinCode()
            
        }else {
            
            showInternetUnable()
            
        }
        
        loginQrViewModel.complete = { [weak self] (pinCode, token, statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode != 503 {
                    
                    let stringCode: String = "\(pinCode)"
                    if stringCode.count == 6{
                        var counter: Int = 0
                        self?.labels.forEach({ (label) in
                            label.text = String(stringCode[counter])
                            counter += 1
                        })
                    }
                    
                    self?.token = token
                    self?.timer = Timer.scheduledTimer(timeInterval: 10, target: self!, selector: #selector(self?.checkAuthorizeToken), userInfo: nil, repeats: true)
                    
                    
                    
                    self?.bottomQRViewModel.initFetchQrToken()
                }else {
                    self?.showErrorServer()
                    
                }
            }
            
        }
        
        bottomQRViewModel.completeToken = { [weak self] (token, accessToken) in
            
            DispatchQueue.main.async {
                
                self?.qrCode.generateQRCode(from: "{ \"type\": \"auth_token\",\"value\": \"\(token)\", \"imgUrl\" : \"https://media.forus.io/assets/me-logo.png\"}")
                self?.timerQR = Timer.scheduledTimer(timeInterval: 7, target: self!, selector: #selector(self?.didCheckAuthorize), userInfo: nil, repeats: true)
                self?.tokenQr = accessToken
                
            }
        }
        
        loginQrViewModel.completeAuthorize = { [weak self] (message, statusCode) in
            
            DispatchQueue.main.async {
                if message == "active"{
                    self?.timer.invalidate()
                    self?.saveNewIdentity(accessToken: self!.token)
                    UserDefaults.standard.set(self?.getCurrentUser().accessToken!, forKey: UserDefaultsName.Token)
                    UserDefaults.standard.set(true, forKey: UserDefaultsName.UserIsLoged)
                    CurrentSession.shared.token = self?.token
                    self?.addShortcuts(application: UIApplication.shared)
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: NotificationName.LoginQR, object: nil)
                }
            }
            
        }
    }
    
    
    @objc func didCheckAuthorize() {
        bottomQRViewModel.initAuthorizeToken(token: tokenQr)
        
        bottomQRViewModel.completeAuthorize = { [weak self] (message) in
            
            DispatchQueue.main.async {
                if message == "active"{
                    self?.timer.invalidate()
                    self?.saveNewIdentity(accessToken: self!.tokenQr)
                    UserDefaults.standard.set(self?.getCurrentUser().accessToken!, forKey: UserDefaultsName.Token)
                    UserDefaults.standard.set(true, forKey: UserDefaultsName.UserIsLoged)
                    CurrentSession.shared.token = self?.tokenQr
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: NotificationName.LoginQR, object: nil)
                    
                }
            }
        }
    }
    
    @objc func checkAuthorizeToken(){
        
        loginQrViewModel.completeAuthorize = { [weak self] (message, statusCode) in
            
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
        loginQrViewModel.initAuthorizeToken(token: token)
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timerQR?.invalidate()
    }
    
    @IBAction func closeQR(_ sender: Any) {
        closeQRAction()
    }
    
    @IBAction func closeGesture(_ sender: Any) {
        closeQRAction()
    }
    
    func closeQRAction(){
        self.bottomConstraint.constant = 647
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (isFinished) in
            self.view.removeFromSuperview()
        })
    }
    
}

// MARK: - Accessibility Protocol

extension BottomQrWithPinViewController: AccessibilityProtocol {
    func setupAccessibility() {
        qrCode.setupAccesibility(description: "Qr Code", accessibilityTraits: .image)
        pinCodeView.setupAccesibility(description: "This is your pin code", accessibilityTraits: .none)
        closeButton.setupAccesibility(description: "Close", accessibilityTraits: .button)
    }
}
