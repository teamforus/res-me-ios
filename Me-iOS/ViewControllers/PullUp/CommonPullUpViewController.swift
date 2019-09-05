//
//  CommonPullUpViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ISHPullUp


@IBDesignable
class CommonPullUpViewController: ISHPullUpViewController {
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            if self.contentViewController != nil && self.bottomViewController != nil {
                print("nil")
            }else {
                commonInit()
            }
    
        }
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    
    private func commonInit() {
        let storyBoard = UIStoryboard(name: "Profile" , bundle: nil)
        let contentVC = storyBoard.instantiateViewController(withIdentifier: "content")
        let bottomVC = storyBoard.instantiateViewController(withIdentifier: "bottom") as! CommonBottomViewController
        contentViewController = contentVC
        bottomViewController = bottomVC
        bottomVC.pullUpController = self
        sizingDelegate = bottomVC
        stateDelegate = bottomVC
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hideTapBar"), object: nil)
    }
    
}
