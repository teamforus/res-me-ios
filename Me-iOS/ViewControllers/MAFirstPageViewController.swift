//
//  MAFirstPageViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 8/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MAFirstPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToLoginQR" {
            let generalVC = didSetPullUP(storyBoardName: "LoginQRAndCodeViewController", segue: segue)
            (generalVC.bottomViewController as! CommonBottomViewController).qrType = .AuthToken
        }
    }
    

}
