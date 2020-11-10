//
//  Extension+UIWindow.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 17.08.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

 public extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewController(from: self.rootViewController)
    }

    static func getVisibleViewController(from vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewController(from: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewController(from: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewController(from: pvc)
            } else {
                return vc
            }
        }
    }
}
