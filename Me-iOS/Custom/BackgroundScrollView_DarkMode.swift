//
//  BackgroundScrollView_DarkMode.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 27.07.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class BackgroundScrollView_DarkMode: UIScrollView {

    @IBInspectable var colorName :String = "Background_DarkTheme" {
         didSet {
             setSelectedColorName()
         }
     }

    override init(frame: CGRect) {
       super.init(frame: frame)
     }
     
     required init(coder: NSCoder) {
       super.init(coder: coder)!
     }
     
     func setSelectedColorName() {
         if #available(iOS 11.0, *) {
           self.backgroundColor = UIColor(named: colorName)
         } else {
           // Fallback on earlier versions
         }
     }

}
