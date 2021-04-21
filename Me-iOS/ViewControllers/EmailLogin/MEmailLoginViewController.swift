//
//  MEmailLoginViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift

class MEmailLoginViewController: UIViewController {
  @IBOutlet weak var emailField: SkyFloatingLabelTextField!
  @IBOutlet weak var validationIcon: UIImageView!
  @IBOutlet weak var confirmButton: ShadowButton!
  
  lazy var emailLoginViewModel: EmailLoginViewModel = {
    return EmailLoginViewModel()
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    keyboardManager()
    validateEmail()
  }
  
  func validateEmail(){
    
    emailLoginViewModel.complete = { [weak self] (message, statusCode) in
      DispatchQueue.main.async {
        KVSpinnerView.dismiss()
        if statusCode == 200 {
          self?.performSegue(withIdentifier: "goToSuccessMail", sender: self)
        }else {
          self?.showSimpleAlert(title: "Email", message: "Such email does not exist.")
        }
      }
    }
  }
  
  func keyboardManager(){
    
    IQKeyboardManager.shared.enable = true
    IQKeyboardManager.shared.enableAutoToolbar = true
  }
  
  @IBAction func validateEmailField(textField:SkyFloatingLabelTextField) {
    
    if validateEmail(emailField.text!){
      
      validationIcon.isHidden = false
      confirmButton.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.9764705882, alpha: 1)
      confirmButton.isEnabled = true
      
    }else{
      
      validationIcon.isHidden = true
      confirmButton.backgroundColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)
      confirmButton.isEnabled = false
    }
  }
  
  
  @IBAction func confirm(_ sender: Any) {
    if isReachable() {
      
      KVSpinnerView.show()
      emailLoginViewModel.initLoginByEmail(email: emailField.text ?? "")
      
    }else {
      
      showInternetUnable()
      
    }
  }
  
  
}
