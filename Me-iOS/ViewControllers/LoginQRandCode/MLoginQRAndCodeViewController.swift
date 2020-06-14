//
//  MLoginQRAndCodeViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/6/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import KVSpinnerView

class MLoginQRAndCodeViewController: UIViewController {
    @IBOutlet var labels: [UILabel]!
    
    lazy var loginQrViewModel: LoginQrAndCodeViewModel = {
        return LoginQrAndCodeViewModel()
    }()
    var timer: Timer! = Timer()
    var token: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPinCode()
        setupCompletions()
        NotificationCenter.default.addObserver(self, selector: #selector(logIn), name: NotificationName.LoginQR, object: nil)
    }
    
    func fetchPinCode() {
        if isReachable() {
            
            KVSpinnerView.show()
            loginQrViewModel.initFetchPinCode()
            
        }else {
            
            showInternetUnable()
            
        }
    }
    
    func setupCompletions() {
        loginQrViewModel.complete = { [weak self] (pinCode, token, statusCode) in
            DispatchQueue.main.async {
                if statusCode != 503 {
                    
                    KVSpinnerView.dismiss()
                    let stringCode: String = "\(pinCode)"
                    if stringCode.count == 6{
                        var counter: Int = 0
                        self?.labels.forEach({ (label) in
                            label.text = String(stringCode[counter])
                            counter += 1
                        })
                    }
                    
                    self?.token = token
                    self?.timer = Timer.scheduledTimer(timeInterval: 10, target: self!, selector: #selector(self?.didCheckAuthorize), userInfo: nil, repeats: true)
                }else {
                    KVSpinnerView.dismiss()
                    self?.showErrorServer()
                    
                }
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
                    self?.performSegue(withIdentifier: "goToMain", sender: self)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13, *) {
        }else {
            self.setStatusBarStyle(.default)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func logIn(){
        performSegue(withIdentifier: "goToMain", sender: self)
    }
    
    @IBAction func loginWithQr(_ sender: Any) {
        
        NotificationCenter.default.post(name: NotificationName.TogleStateWindow, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMain" {
            let barVC = segue.destination as? UITabBarController
            let nVC = barVC!.viewControllers![0] as? HiddenNavBarNavigationController
            let vc = nVC?.topViewController as? MVouchersViewController
            vc?.isFromLogin = true
        }
    }
    
}

extension MLoginQRAndCodeViewController{
    
    @objc func didCheckAuthorize() {
        loginQrViewModel.initAuthorizeToken(token: token)
    }
}
