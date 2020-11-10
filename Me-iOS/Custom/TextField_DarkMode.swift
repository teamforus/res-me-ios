//
//  TextField_DarkMode.swift
//  Me-iOS
//
//  Created by mac on 7/20/20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class TextField_DarkMode:SkyFloatingLabelTextField  {

  override init(frame: CGRect) {
      super.init(frame: frame)
      setDarkModeBackground()
    }
    
    required init(coder: NSCoder) {
      super.init(coder: coder)!
      setDarkModeBackground()
    }
    
    func setDarkModeBackground(){
      if #available(iOS 11.0, *) {
        self.textColor = UIColor(named: "Black_Light_DarkTheme")
      } else {
        // Fallback on earlier versions
      }
    }

}
