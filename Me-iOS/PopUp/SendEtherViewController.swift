//
//  SendEtherViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 8/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class SendEtherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showAnimate()
    }

    @IBAction func confirm(_ sender: Any) {
        removeAnimate()
    }

    
    @IBAction func close(_ sender: Any) {
        removeAnimate()
    }
    
}
