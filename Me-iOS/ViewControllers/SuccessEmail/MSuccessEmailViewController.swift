//
//  MSuccessEmailViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MSuccessEmailViewController: UIViewController {
    @IBOutlet weak var textLabel: UILabel!
    
    var email: String!
    
    lazy var successEmailViewModel: SuccessEmailViewModel = {
        return SuccessEmailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addObservers()
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(logIn), name: NotificationName.LoginQR, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(authorizeToken(notifcation:)),
            name: NotificationName.AuthorizeTokenEmail,
            object: nil)
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(authorizeRegistrationToken(notifcation:)),
        name: NotificationName.AuthorizeRegistrationTokenEmail,
        object: nil)
    }
    
    func setupView() {
        let mainString = String(format: Localize.clickOnTheLinkYouReceivedOnToContinue(email))
        let range = (mainString as NSString).range(of: email ?? "")
        
        let attributedString = NSMutableAttributedString(string:mainString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.9764705882, alpha: 1) , range: range)
        
        textLabel.attributedText = attributedString
    }
    
    @objc func authorizeToken(notifcation: Notification){
        
        successEmailViewModel.complete = { [weak self] (token) in
            
            DispatchQueue.main.async {
                
                self?.saveNewIdentity(accessToken: token)
                UserDefaults.standard.set(token, forKey: UserDefaultsName.Token)
                UserDefaults.standard.set(true, forKey: UserDefaultsName.UserIsLoged)
                CurrentSession.shared.token = token
                self?.addShortcuts(application: UIApplication.shared)
                UserDefaults.standard.synchronize()
                self?.performSegue(withIdentifier: "goToSuccessRegister", sender: self)
                
            }
        }
        
        if let token = notifcation.userInfo?["authToken"] as? String {
            
            successEmailViewModel.initCheckAuthorize(token: token)
            
        }
    }
    
    @objc func authorizeRegistrationToken(notifcation: Notification){
        
        successEmailViewModel.completeRegistration = { [weak self] (token) in
            
            DispatchQueue.main.async {
                
                self?.saveNewIdentity(accessToken: token)
                UserDefaults.standard.set(token, forKey: UserDefaultsName.Token)
                UserDefaults.standard.set(true, forKey: UserDefaultsName.UserIsLoged)
                CurrentSession.shared.token = token
                self?.addShortcuts(application: UIApplication.shared)
                UserDefaults.standard.synchronize()
                self?.performSegue(withIdentifier: "goToSuccessRegister", sender: self)
                
            }
        }
        
        if let token = notifcation.userInfo?["authToken"] as? String {
            
            successEmailViewModel.initSignUp(token: token)
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func openMailApp(_ sender: Any) {
        if let mailURL = NSURL(string: "message://") {
            if UIApplication.shared.canOpenURL(mailURL as URL) {
                UIApplication.shared.open(mailURL as URL, options: [:],
                                          completionHandler: {
                                            (success) in }) }
            
        }
    }
    
    @objc func logIn(){
        performSegue(withIdentifier: "goToSuccessRegister", sender: self)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func showQrWithPin(_ sender: Any) {
        let popOverVC = BottomQrWithPinViewController(nibName: "BottomQrWithPinViewController", bundle: nil)
    
        showPopUPWithAnimation(vc: popOverVC)
        
    }
}
