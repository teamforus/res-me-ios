//
//  EnablePersonalInformationViewController.swift
//  Me-iOS
//
//  Created by Daniel Tcacenco on 3/2/20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class EnablePersonalInformationViewController: UIViewController {
    @IBOutlet weak var identificationView: CustomCornerUIView!
    @IBOutlet weak var identificationSwitch: UISwitchCustom!
    @IBOutlet weak var titleLabel: UILabel_DarkMode!
  
  override func viewDidLoad() {
        super.viewDidLoad()
        setupAccessibility()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let barVC = segue.destination as? UITabBarController
        let nVC = barVC!.viewControllers![0] as? HiddenNavBarNavigationController
        let vc = nVC?.topViewController as? MVouchersViewController
        vc?.isFromLogin = true
    }
    
    @IBAction func enableSendIndenity(_ sender: UISwitch) {
        
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: UserDefaultsName.AddressIndentityCrash)
        }else {
            UserDefaults.standard.set(false, forKey: UserDefaultsName.AddressIndentityCrash)
        }
    }
}

// MARK: - Accessibility Protocol

extension EnablePersonalInformationViewController: AccessibilityProtocol {
    func setupAccessibility() {
        identificationView.setupAccesibility(description: "Turn on/off to send indentification number in crash report, on right side you can enable this option. ", accessibilityTraits: .none)
        identificationSwitch.setupAccesibility(description: "Turn on/off indentification number", accessibilityTraits: .none)
      titleLabel.setupAccesibility(description: Localize.informatie_delen(), accessibilityTraits: .header)
    }
}
