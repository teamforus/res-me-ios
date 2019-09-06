//
//  MRegisterViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift

class MRegisterViewController: UIViewController {
    @IBOutlet weak var primaryEmailField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmEmailField: SkyFloatingLabelTextField!
    @IBOutlet weak var firstNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var validationPrimaryEmail: UIImageView!
    @IBOutlet weak var validationConfirmEmail: UIImageView!
    @IBOutlet weak var doneButton: ShadowButton!
    
    lazy var registerViewModel: RegisterViewModel = {
        return RegisterViewModel()
    }()
    
    lazy var emailLoginViewModel: EmailLoginViewModel = {
        return EmailLoginViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        registerViewModel.complete = { [weak self] (response, statusCode) in
            
            DispatchQueue.main.async {
                if statusCode == 422{
                    self?.showSimpleAlertWithAction(title: "Do you want to login instead?".localized(), message: "Your e-mail address is already used, do you instead want to login using this e-mail address?".localized(), okAction: UIAlertAction(title: "Confirm".localized(), style: .default, handler: { (action) in
                        
                        self?.emailLoginViewModel.initLoginByEmail(email: self?.primaryEmailField.text ?? "")
                    }), cancelAction: UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { (action) in
                        
                    }))
                }else if statusCode == 500 {
                    
                    
                }else {
                    self?.performSegue(withIdentifier: "goToConfirm", sender: nil)
                }
            }
        }
        
        emailLoginViewModel.complete = { [weak self] (statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode == 200 {
                    
                    self?.performSegue(withIdentifier: "goToSuccessMail", sender: self)
                    
                }
            }
        }
    }
    
    
    @IBAction func done(_ sender: UIButton){
        
        if validation(fields: [primaryEmailField, confirmEmailField, firstNameField, lastNameField],
                      texts: [primaryEmailField.text!, confirmEmailField.text!, firstNameField.text!, lastNameField.text!]) {
            if isReachable() {
                
            registerViewModel.initRegister(identity: Identity(pin_code: "1111",
                                                              records: RecordsIndenty(primary_email: primaryEmailField.text!,
                                                                                      family_name: lastNameField.text!,
                                                                                      given_name: firstNameField.text!)))
            }else {
                
                showInternetUnable()
                
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let successRegisterVC = segue.destination as? MConfirmRegisterViewController {
            
                successRegisterVC.firstName = firstNameField.text
                successRegisterVC.lastName = lastNameField.text
                successRegisterVC.primaryEmail = primaryEmailField.text
            
            
        }
    }

}

extension MRegisterViewController{
    
    @IBAction func validateEmailField(textField:SkyFloatingLabelTextField) {
        
        if textField == primaryEmailField{
            
            if validateEmail(primaryEmailField.text!){
                
                validationPrimaryEmail.isHidden = false
                confirmEmailField.isEnabled = true
                
            }else{
                
                validationPrimaryEmail.isHidden = true
                confirmEmailField.isEnabled = false
                
            }
            
        }else if textField == confirmEmailField{
            
            if confirmEmailField.text == primaryEmailField.text{
                
                validationPrimaryEmail.isHidden = false
                validationConfirmEmail.isHidden = false
                doneButton.isEnabled = true
                doneButton.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.9764705882, alpha: 1)
                
            }else{
                
                validationPrimaryEmail.isHidden = true
                validationConfirmEmail.isHidden = true
                doneButton.isEnabled = false
                doneButton.backgroundColor = #colorLiteral(red: 0.7647058824, green: 0.7647058824, blue: 0.7647058824, alpha: 1)
                
            }
        }
    }
    
    fileprivate func validation( fields: [SkyFloatingLabelTextField], texts: [String]) -> Bool{
        var validation: Bool! = false
        
        fields.forEach { (textField) in
            
            if textField.text != "" {
                
                textField.errorMessage = nil
                
            }else {
                
                textField.errorMessage = "Field is requierd".localized()
                
            }
        }
        
        if texts.contains(""){
            
            validation = false
            
        }else {
            
            validation = true
            
        }
        
        return validation
    }
    
    
    
}
