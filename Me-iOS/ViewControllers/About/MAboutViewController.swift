//
//  MAboutViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 6/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAboutViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAccessibility()
    }
}

// MARK: - Accessibility Protocol

extension MAboutViewController: AccessibilityProtocol {
    func setupAccessibility() {
        closeButton.setupAccesibility(description: "Close", accessibilityTraits: .button)
    }
}
