//
//  CloseButto_DarkMode.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 27.07.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class CloseButton_DarkMode: UIButton {

     override init(frame: CGRect) {
       super.init(frame: frame)
       setDarkModeButton()
     }
     
     required init(coder: NSCoder) {
       super.init(coder: coder)!
       setDarkModeButton()
     }
     
     func setDarkModeButton(){
       let image = UIImage(named: "closeLines")?.withRenderingMode(.alwaysTemplate)
       self.setImage(image, for: .normal)
       if #available(iOS 11.0, *) {
         self.tintColor = UIColor(named: "Black_Light_DarkTheme")
       } else {
         // Fallback on earlier versions
       }
     }

}
