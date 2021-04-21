//
//  MAFirstPageViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 8/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

enum EnvironmentType: Int {
  case production = 0
  case alpha = 1
  case demo = 2
  case dev = 3
  case custom = 4
}

import UIKit
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift

class MAFirstPageViewController: UIViewController {
  @IBOutlet weak var environmnetView: UIStackView!
  @IBOutlet weak var chooseEnvironmentButton: UIButton!
  @IBOutlet weak var emailField: SkyFloatingLabelTextField!
  @IBOutlet weak var validationImage: UIImageView!
  @IBOutlet weak var confirmButton: ShadowButton!
  @IBOutlet weak var showQRCodeButton: ShadowButton!
  @IBOutlet weak var welcomeLabel: UILabel_DarkMode!
  
  lazy var emailLoginViewModel: EmailLoginViewModel = {
    return EmailLoginViewModel()
  }()
  
  lazy var registerViewModel: RegisterViewModel = {
    return RegisterViewModel()
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    IQKeyboardManager.shared.enable = true
    IQKeyboardManager.shared.enableAutoToolbar = true
    setupAccessibility()
    getApiRequest()
  }
  
  
  func getApiRequest(){
    #if DEV
    chooseEnvironmentButton.isHidden = false
    if UserDefaults.standard.string(forKey: UserDefaultsName.EnvironmentURL) == nil{
      
      CheckWebSiteReacheble.checkWebsite(url: "https://develop.test.api.forus.io") { (isReacheble) in
        if isReacheble { UserDefaults.standard.setValue("https://develop.test.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
        }else {
          UserDefaults.standard.setValue("https://dev.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
        }
      }
      
      chooseEnvironmentButton.setTitle("Dev", for: .normal)
      UserDefaults.standard.setValue("Dev", forKey: UserDefaultsName.EnvironmentName)
    }else {
      
      chooseEnvironmentButton.setTitle(UserDefaults.standard.string(forKey: UserDefaultsName.EnvironmentName), for: .normal)
    }
    #endif
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    addObservers()
    setUpUI()
  }
  
  func addObservers(){
    NotificationCenter.default.addObserver(self, selector: #selector(logIn), name: NotificationName.LoginQR, object: nil)
  }
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    setUpUI()
  }
  
  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    setUpUI()
    
  }
  
  func setUpUI(){
    if #available(iOS 12.0, *) {
      if self.traitCollection.userInterfaceStyle == .dark {
        emailField.textColor = .white
        emailField.selectedLineColor = .white
      } else {
        emailField.textColor = .black
        emailField.selectedLineColor = .black
      }
    } else {
      // Fallback on earlier versions
    }
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeObservers()
  }
  
  func removeObservers(){
    NotificationCenter.default.removeObserver(self, name: NotificationName.LoginQR, object: nil)
  }
  
  @IBAction func chooseEnvironment(_ sender: UIButton) {
    environmnetView.isHidden = true
    switch sender.tag {
    case EnvironmentType.production.rawValue:
      UserDefaults.standard.setValue("https://api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
      UserDefaults.standard.setValue("Production", forKey: UserDefaultsName.EnvironmentName)
      chooseEnvironmentButton.setTitle("Production", for: .normal)
      break
    case EnvironmentType.alpha.rawValue:
      
      UserDefaults.standard.setValue("https://staging.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
      UserDefaults.standard.setValue("Alpha", forKey: UserDefaultsName.EnvironmentName)
      chooseEnvironmentButton.setTitle("Alpha", for: .normal)
      break
    case EnvironmentType.demo.rawValue:
      UserDefaults.standard.setValue("https://demo.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
      UserDefaults.standard.setValue("Demo", forKey: UserDefaultsName.EnvironmentName)
      chooseEnvironmentButton.setTitle("Demo", for: .normal)
      break
    case EnvironmentType.dev.rawValue:
      UserDefaults.standard.setValue("https://dev.api.forus.io/api/v1/", forKey: UserDefaultsName.EnvironmentURL)
      UserDefaults.standard.setValue("Dev", forKey: UserDefaultsName.EnvironmentName)
      chooseEnvironmentButton.setTitle("Dev", for: .normal)
      break
      
    case EnvironmentType.custom.rawValue:
      let alertController = UIAlertController(title: "Add custom URL", message: "", preferredStyle: .alert)
      alertController.addTextField { (textField : UITextField!) -> Void in
        textField.placeholder = "Enter Base URL"
        if self.chooseEnvironmentButton.titleLabel?.text == "Custom" {
          textField.text = UserDefaults.standard.string(forKey: UserDefaultsName.EnvironmentURL)
        }
      }
      let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
        let firstTextField = alertController.textFields![0] as UITextField
        UserDefaults.standard.setValue(firstTextField.text ?? "", forKey: UserDefaultsName.EnvironmentURL)
        UserDefaults.standard.setValue("Custom", forKey: UserDefaultsName.EnvironmentName)
        self.chooseEnvironmentButton.setTitle("Custom", for: .normal)
      })
      let cancelAction = UIAlertAction(title: Localize.cancel(), style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
      
      alertController.addAction(cancelAction)
      alertController.addAction(saveAction)
      
      self.present(alertController, animated: true, completion: nil)
      break
    default:
      break
    }
    
  }
  
  @IBAction func showEnvironment(_ sender: Any) {
    environmnetView.isHidden = !environmnetView.isHidden
  }
  
  @IBAction func showQrWithPin(_ sender: UIButton) {
    let popOverVC = BottomQrWithPinViewController(nibName: "BottomQrWithPinViewController", bundle: nil)
    showPopUPWithAnimation(vc: popOverVC)
  }
  
  @objc func logIn(){
    performSegue(withIdentifier: "goToSuccessRegister", sender: self)
  }
  
  @IBAction func validateEmail(_ sender: SkyFloatingLabelTextField) {
    if validateEmail(emailField.text!){
      
      validationImage.isHidden = false
      confirmButton.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.9764705882, alpha: 1)
      confirmButton.isEnabled = true
      
    }else{
      
      validationImage.isHidden = true
      confirmButton.backgroundColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)
      confirmButton.isEnabled = false
    }
  }
  
  @IBAction func logInOrSignUp(_ sender: Any) {
    
    internetConnection()
    registerApiRequest()
    emailApiRequest()
  }
  
  func internetConnection(){
    if isReachable() {
      registerViewModel.initRegister(identity: Identity(email: emailField.text ?? ""))
    }else {
      showInternetUnable()
    }
  }
  
  func registerApiRequest(){
    registerViewModel.complete = { [weak self] (response, statusCode) in
      DispatchQueue.main.async {
        if statusCode == 422 {
          self?.emailLoginViewModel.initLoginByEmail(email: self?.emailField.text ?? "")
        }else if statusCode == 500 {
          self?.showSimpleAlertWithSingleAction(title: Localize.error_exclamation(), message: "", okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
          }))
        }else {
          self?.performSegue(withIdentifier: "goToSuccessMail", sender: nil)
        }
      }
    }
  }
  
  func emailApiRequest(){
    emailLoginViewModel.complete = { [weak self] (message, statusCode) in
      
      DispatchQueue.main.async {
        
        if statusCode != 500 {
          
          self?.performSegue(withIdentifier: "goToSuccessMail", sender: self)
          
        }else {
          self?.showSimpleAlertWithSingleAction(title: Localize.error_exclamation(), message: "", okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
          }))
        }
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToSuccessMail" {
      let vc = segue.destination as! MSuccessEmailViewController
      vc.email = emailField.text ?? ""
    }
  }
}

// MARK: - Accessibility Protocol

extension MAFirstPageViewController: AccessibilityProtocol {
  func setupAccessibility() {
    emailField.setupAccesibility(description: "Enter your email", accessibilityTraits: .none)
    confirmButton.setupAccesibility(description: Localize.confirm(), accessibilityTraits: .button)
    showQRCodeButton.setupAccesibility(description: "Show Qr Code and Pin Code", accessibilityTraits: .button)
    validationImage.setupAccesibility(description: "Email is valid", accessibilityTraits: .image)
    welcomeLabel.setupAccesibility(description: Localize.welcome_to_me(), accessibilityTraits: .header)
  }
}
