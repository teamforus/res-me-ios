//
//  MACrashConfirmViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 1/15/19.
//  Copyright © 2019 Foundation Forus. All rights reserved.
//

import UIKit

class MCrashConfirmViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimate()
    }
    
    @IBAction func confirmCrashAddress(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: UserDefaultsName.AddressIndentityCrash)
        removeAnimate()
    }
    
    @IBAction func cancel(_ sender: Any) {
        removeAnimate()
    }
}
