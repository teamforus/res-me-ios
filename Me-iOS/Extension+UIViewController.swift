//
//  Extensions.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication
import CoreData
import IQKeyboardManagerSwift
import StoreKit

extension UIViewController{
    
    @IBAction func back(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dismiss(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    func showToast(message : String, messageButton: String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 15, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 30, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "GoogleSans-Regular", size: 11.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        let toastLabel2 = UILabel(frame: CGRect(x: 15, y: self.view.frame.size.height-50, width: self.view.frame.size.width - 30, height: 35))
        toastLabel2.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel2.textColor = UIColor.white
        toastLabel2.textAlignment = .center;
        toastLabel2.font = UIFont(name: "GoogleSans-Regular", size: 12.0)
        toastLabel2.minimumScaleFactor = 0.5
        toastLabel2.adjustsFontSizeToFitWidth = true
        toastLabel2.text = messageButton
        toastLabel2.alpha = 1.0
        toastLabel2.layer.cornerRadius = 10;
        toastLabel2.clipsToBounds  =  true
        
        let toastButton = UIButton(frame: CGRect(x: 15, y: self.view.frame.size.height-50, width: self.view.frame.size.width - 30, height: 35))
        toastButton.backgroundColor = .clear
        toastButton.addTarget(self, action: #selector(self.goToSettings(sender:)), for: .touchUpInside)
        
        self.view.addSubview(toastLabel)
        self.view.addSubview(toastButton)
        self.view.addSubview(toastLabel2)
        UIView.animate(withDuration: 5.0, delay: 1.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
            toastLabel2.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
            toastLabel2.removeFromSuperview()
            toastButton.removeFromSuperview()
        })
    }
    
    func enableKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    func showSimpleToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 15, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 30, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "GoogleSans-Regular", size: 11.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.9, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    @objc func goToSettings( sender :UIButton){
        ScanPermission.goToSystemSetting()
    }
    
    func showSimpleAlert(title:String, message: String){
        
        let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        allertController.addAction(UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
            
        }))
        
        self.present(allertController, animated: true)
    }
    
    func showSimpleAlertWithAction(title:String, message: String, okAction: UIAlertAction, cancelAction: UIAlertAction){
        
        let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        allertController.addAction(cancelAction)
        
        allertController.addAction(okAction)
        
        
        
        self.present(allertController, animated: true)
        
    }
    
    func showInternetUnable(){
        let alert: UIAlertController
        alert = UIAlertController(title: Localize.warning(), message: Localize.no_internet_conecction(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
        }))
        
        self.present(alert, animated: true)
    }
    
    func showErrorServer(){
        let alert: UIAlertController
        alert = UIAlertController(title: Localize.warning(), message: Localize.currently_maintenance_being_done(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
        }))
        
        self.present(alert, animated: true)
    }
    
    func showSimpleAlertWithSingleAction(title:String, message: String, okAction: UIAlertAction) {
        
        let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        allertController.addAction(okAction)
        
        
        self.present(allertController, animated: true)
        
        
    }
    
    func validateEmail(_ candidate: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    @IBAction func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    
    func getLanguageISO() -> String {
        return Locale.current.languageCode!
    }
    
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.setValue(style == .lightContent ? UIColor.white : .black, forKey: "foregroundColor")
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        
        self.showSimpleAlertWithAction(title: Localize.log_out(), message: Localize.are_you_sure_you_want_log_out(),
                                       okAction: UIAlertAction(title: Localize.confirm(), style: .default, handler: { (action) in
                                        
                                        self.logoutOptions()
                                        
                                       }),
                                       cancelAction: UIAlertAction(title: Localize.cancel(), style: .cancel, handler: { (action) in
                                        
                                       }))
        
        
        
    }
    
    func logoutOptions() {
        let voucherViewModel: VouchersViewModel = {
            return VouchersViewModel()
        }()
        
        voucherViewModel.deletePushToken(token: UserDefaults.standard.string(forKey: "TOKENPUSH") ?? "")
        
        voucherViewModel.completeDeleteToken = { [unowned self] (statusCode) in
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.logoutAction()
                }else if statusCode == 422 {
                    self.logoutAction()
                }else if statusCode == 404 {
                    self.showSimpleAlertWithSingleAction(title: Localize.error(), message: "", okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                    }))
                }else if statusCode == 500 {
                    self.showSimpleAlertWithSingleAction(title: Localize.error(), message: "", okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                    }))
                }else if statusCode == 401 {
                    self.logoutAction()
                }
            }
        }
    }
    
    func logoutAction(){
        UserDefaults.standard.setValue(false, forKey: UserDefaultsName.AddressIndentityCrash)
        UserDefaults.standard.setValue(false, forKey: UserDefaultsName.UseTouchID)
        UserDefaults.standard.setValue(false, forKey: UserDefaultsName.StartFromScanner)
        self.deleteEntity(entityName: "User")
        UserDefaults.standard.setValue("", forKey: UserDefaultsName.Token)
        self.removeShortcutItem(application: UIApplication.shared)
        UserDefaults.standard.set("", forKey: ALConstants.kPincode)
        UserDefaults.standard.setValue(false, forKey: UserDefaultsName.UserIsLoged)
        let storyboard:UIStoryboard = UIStoryboard(name: "First", bundle: nil)
        let navigationController:HiddenNavBarNavigationController = storyboard.instantiateInitialViewController() as! HiddenNavBarNavigationController
        let firstPageVC:UIViewController = storyboard.instantiateViewController(withIdentifier: "firstPage") as UIViewController
        navigationController.viewControllers = [firstPageVC]
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func deleteEntity(entityName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            appDelegate.saveContext()
        } catch _ as NSError {
            
        }
        
    }
    
    func didChooseAppLocker(title: String, subTitle: String, cancelButtonIsVissible: Bool, mode: ALMode){
        var appearance = ALAppearance()
        appearance.image = UIImage(named: "lock")!
        appearance.title = title
        appearance.subtitle = subTitle
        appearance.isSensorsEnabled = UserDefaults.standard.bool(forKey: UserDefaultsName.UseTouchID)
        appearance.cancelIsVissible = cancelButtonIsVissible
        appearance.delegate = self
        
        AppLocker.present(with: mode, and: appearance, withController: self)
    }
    
    func passcodeIsSet() -> Bool {
        
        if UserDefaults.standard.string(forKey: ALConstants.kPincode) == "" || UserDefaults.standard.string(forKey: ALConstants.kPincode) == nil {
            return false
        }
        
        return true
    }
    
    func showPopUP(vc: UIViewController) {
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
        
    }
    
    func showPopUPWithAnimation(vc: UIViewController) {
        
        self.addChild(vc)
        vc.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(vc.view)
        
    }
    
    func faceIDAvailable() -> Bool {
        if #available(iOS 11.0, *) {
            let context = LAContext()
            return (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) && context.biometryType == .faceID)
        }
        return false
    }
    
    var deviceAuthentification: String {
            if faceIDAvailable() {
                return "Face ID"
            }else {
                return "Touch ID"
            }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func isReachable() -> Bool {
        let reachablity = try! Reachability()
        if reachablity.connection == .unavailable{
            
            return false
            
        }else {
            
            return true
            
        }
    }
    
    func addShortcuts(application: UIApplication) {
        let voucherItem = UIMutableApplicationShortcutItem(type: "Vouchers", localizedTitle: Localize.vouchers(), localizedSubtitle: "", icon: UIApplicationShortcutIcon(templateImageName: "wallet"), userInfo: nil)
        
        let qrItem = UIMutableApplicationShortcutItem(type: "QR", localizedTitle: "QR", localizedSubtitle: "", icon: UIApplicationShortcutIcon(templateImageName: "iconGrey"), userInfo: nil)
        
        let recordItem = UIMutableApplicationShortcutItem(type: "Profile", localizedTitle: Localize.profile(), localizedSubtitle: "", icon: UIApplicationShortcutIcon(templateImageName: "activeBlue"), userInfo: nil)
        
        application.shortcutItems = [voucherItem, qrItem, recordItem]
    }
    
    func removeShortcutItem(application: UIApplication){
        application.shortcutItems = []
    }
    
    func saveNewIdentity( accessToken: String){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate!.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        _ = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(true, forKey: "currentUser")
        newUser.setValue("", forKey: "pinCode")
        newUser.setValue(accessToken, forKey: "accessToken")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func getCurrentUser() -> User{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "currentUser == YES")
        do {
            let results = try context.fetch(fetchRequest) as? [User]
            if results?.count != 0 {
                return results![0]
            }
        } catch {}
        return User()
    }
}

extension UIViewController{
    
    func didSetPullUP(storyboard: UIStoryboard, segue: UIStoryboardSegue) -> CommonPullUpViewController {
        
        let passVC = segue.destination as! CommonPullUpViewController
        
        passVC.contentViewController = storyboard.instantiateViewController(withIdentifier: "content")
        
        passVC.bottomViewController = storyboard.instantiateViewController(withIdentifier: "bottom")
        
        (passVC.bottomViewController as! CommonBottomViewController).pullUpController = passVC
        passVC.sizingDelegate = (passVC.bottomViewController as! CommonBottomViewController)
        passVC.stateDelegate = (passVC.bottomViewController as! CommonBottomViewController)
        
        return passVC
    }
}

extension UIViewController: AppLockerDelegate {
    
    func closePinCodeView(typeClose: typeClose) {
        
    }
}

 // MARK: - Close Update Notifier

extension UIViewController {
    @objc func closeUpdateNotifier() {
        NotificationCenter.default.post(name: NotificationName.CloseAppNotifier, object: nil)
    }
}

// MARK: - SKStore for update app

extension UIViewController {
    @objc func updateApp(){
        openStoreProductWithiTunesItemIdentifier(identifier: "1422610676")
    }
    
    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self

        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProduct(withParameters: parameters) { [weak self] (loaded, error) -> Void in
            if loaded {
                self?.present(storeViewController, animated: true, completion: nil)
            }
        }
    }
}

extension UIViewController: SKStoreProductViewControllerDelegate {
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
