//
//  MProfileViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import MessageUI
import Crashlytics

class MProfileViewController: UIViewController {
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var buttonConstraingHeight: NSLayoutConstraint!
    @IBOutlet weak var changePassCodeView: CustomCornerUIView!
    @IBOutlet weak var turnOffPascodeView: CustomCornerUIView!
    @IBOutlet weak var useFaceIdView: CustomCornerUIView!
    @IBOutlet weak var faceIdVerticalSpacing: NSLayoutConstraint!
    @IBOutlet weak var changePasscodeLabel: UILabel!
    @IBOutlet weak var useSensorIdLabel: UILabel!
    @IBOutlet weak var crashButton: UIButton!
    @IBOutlet weak var startScannerSwitch: UISwitchCustom!
    @IBOutlet weak var userFaceIdSwitch: UISwitchCustom!
    @IBOutlet weak var crashReportSwitch: UISwitchCustom!
    @IBOutlet weak var startFromScannerView: CustomCornerUIView!
    @IBOutlet weak var sendCrashReportView: CustomCornerUIView!
    @IBOutlet weak var aboutMeButton: UIButton!
    @IBOutlet weak var feedBackButton: UIButton!
    @IBOutlet weak var logoutButton: ShadowButton!
    @IBOutlet weak var openRecordsButton: UIButton!
    
    lazy var profileViewModel: ProfileViewModel = {
        return ProfileViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAboutMeAappButton()
        fetchUserData()
        setupUserDefaults()
        setupAccessibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSecurity()
    }
  
  
}

// MARK: - IBActions

extension MProfileViewController {
    
  @IBAction func privacyAndSecurity(_ sender: Any) {
    let vc = MPrivacyViewController()
    let navVC = UINavigationController(rootViewController: vc)
    self.present(navVC, animated: true)
    }
  
    @IBAction func switchStartFromScanner(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.setValue(true, forKey: UserDefaultsName.StartFromScanner)
        }else {
            UserDefaults.standard.setValue(false, forKey: UserDefaultsName.StartFromScanner)
        }
    }
    
    @IBAction func useFaceId(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.setValue(true, forKey: UserDefaultsName.UseTouchID)
        }else {
            UserDefaults.standard.setValue(false, forKey: UserDefaultsName.UseTouchID)
        }
    }
    
    @IBAction func sendCrashReports(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.setValue(true, forKey: UserDefaultsName.AddressIndentityCrash)
        }else {
            UserDefaults.standard.setValue(false, forKey: UserDefaultsName.AddressIndentityCrash)
        }
    }
    
    @IBAction func feedback(_ sender: Any) {
        
        showSimpleAlertWithAction(title: "Support", message: Localize.would_you_like_send_us_your_feedback_by_email(),
                                  okAction: UIAlertAction(title: Localize.cancel(), style: .cancel, handler: { (action) in
                                  }),
                                  cancelAction: UIAlertAction(title: Localize.confirm(), style: .default, handler: { (action) in
                                    if MFMailComposeViewController.canSendMail() {
                                        let composeVC = MFMailComposeViewController()
                                        composeVC.mailComposeDelegate = self
                                        composeVC.setToRecipients([" support@forus.io"])
                                        composeVC.setSubject(Localize.my_feedback_about_me_app())
                                        composeVC.setMessageBody("", isHTML: false)
                                        self.present(composeVC, animated: true, completion: nil)
                                    }else{
                                        self.showSimpleAlert(title: Localize.warning(), message: Localize.mail_services_are_not_available())
                                    }
                                  }))
    }
    
    @IBAction func crash(_ sender: Any) {
        Crashlytics.sharedInstance().crash()
    }
    
    @IBAction func creatEditPasscode(_ sender: Any) {
        
        if passcodeIsSet() {
            didChooseAppLocker(title: Localize.change_passcode(), subTitle: Localize.enter_your_old_code(), cancelButtonIsVissible: true, mode: .change)
        }else {
            didChooseAppLocker(title: Localize.login_code(), subTitle: Localize.enter_a_new_login_code(), cancelButtonIsVissible: true, mode: .create)
        }
    }
    
    @IBAction func deletePasscode(_ sender: Any) {
        
        didChooseAppLocker(title: Localize.turn_off_login_code(), subTitle: Localize.enter_your_login_code(), cancelButtonIsVissible: true, mode: .deactive)
    }
  
  
}

// MARK: - SetupView

extension MProfileViewController {
    
    private func setupView() {
        profileViewModel.vc = self
        if let versionApp = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
            appVersionLabel.text = "\(versionApp)"
        }
        
        #if (DEV || ALPHA )
        crashButton.isHidden = false
        #else
        crashButton.isHidden = true
        #endif
    }
    
    func setupAboutMeAappButton() {
        if #available(iOS 11.0, *) {
            self.aboutMeButton.setTitleColor(UIColor(named: "Black_Light_DarkTheme"), for: .normal)
        } else { }
    }
    
    private func fetchUserData() {
        if isReachable() {
            profileViewModel.initProfile()
        }else {
            showInternetUnable()
        }
        
        profileViewModel.complete = { [weak self] (email, address) in
            
            DispatchQueue.main.async {
                self?.profileNameLabel.isHidden = true
                self?.emailLabel.text = email
            }
        }
    }
    
    private func setupUserDefaults() {
        if UserDefaults.standard.bool(forKey: UserDefaultsName.StartFromScanner) {
            startScannerSwitch.isOn = true
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaultsName.UseTouchID) {
            userFaceIdSwitch.isOn = true
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaultsName.AddressIndentityCrash) {
            crashReportSwitch.isOn = true
        }
    }
    
    private func setupSecurity() {
        if faceIDAvailable() {
            useSensorIdLabel.text = Localize.turn_on_face_ID()
        }else {
            useSensorIdLabel.text = Localize.turn_on_touch_ID()
        }
        
        if passcodeIsSet() {
            changePasscodeLabel.text = Localize.change_passcode()
            self.didUpdateButtonStackView(isHiddeButtons: false, buttonHeightConstant: 249, verticalConstant: 66)
        }else{
            changePasscodeLabel.text = Localize.create_passcode()
            self.didUpdateButtonStackView(isHiddeButtons: true, buttonHeightConstant: 130, verticalConstant: 10)
        }
    }
}

// MARK: - UpdateButtons

extension MProfileViewController {
    
    func didUpdateButtonStackView(isHiddeButtons: Bool, buttonHeightConstant: CGFloat, verticalConstant: CGFloat){
        buttonConstraingHeight.constant = buttonHeightConstant
        faceIdVerticalSpacing.constant = verticalConstant
        turnOffPascodeView.isHidden = isHiddeButtons
        useFaceIdView.isHidden = isHiddeButtons
    }
    
}

// MARK: - Accessibility Protocol

extension MProfileViewController: AccessibilityProtocol {
    func setupAccessibility() {
        openRecordsButton.setupAccesibility(description: "Open record list", accessibilityTraits: .button)
        startFromScannerView.setupAccesibility(description: "Start from scanner view, on right side you can enable this option.", accessibilityTraits: .none)
        startScannerSwitch.setupAccesibility(description: "Turn on/off start from scanner", accessibilityTraits: .none)
        changePassCodeView.setupAccesibility(description: "Change set passcode", accessibilityTraits: .button)
        turnOffPascodeView.setupAccesibility(description: "Turn off passcode", accessibilityTraits: .button)
        useFaceIdView.setupAccesibility(description: "Use sensor ID for login, on right side you can enable this option.", accessibilityTraits: .none)
        userFaceIdSwitch.setupAccesibility(description: "Turn on/off sensor ID", accessibilityTraits: .none)
        sendCrashReportView.setupAccesibility(description: "Send crash reports, on right side you can enable this option.", accessibilityTraits: .none)
        crashReportSwitch.setupAccesibility(description: "Turn on/off crash reports", accessibilityTraits: .none)
        aboutMeButton.setupAccesibility(description: "Open About Me App", accessibilityTraits: .button)
        feedBackButton.setupAccesibility(description: "Send feedback by email", accessibilityTraits: .button)
        logoutButton.setupAccesibility(description: Localize.log_out(), accessibilityTraits: .button)
    }
}

// MARK: - Mail Delegate

extension MProfileViewController: MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
