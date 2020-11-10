//
//  UILabel_DarkMode.swift
//  Me-iOS
//
//  Created by mac on 7/15/20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class UILabel_DarkMode: UILabel {

  override init(frame: CGRect) {
      super.init(frame: frame)
      setDarkModeBackground()
    }
  @IBInspectable var colorName :String = "Background_DarkTheme" {
    didSet {
      setSelectedColorName()
    }
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
  func setSelectedColorName() {
    if #available(iOS 11.0, *) {
      self.textColor = UIColor(named: colorName)
    } else {
      // Fallback on earlier versions
    }
  }
}

//class UIButton_DarkMode: UIButton {
//
//  override init(frame: CGRect) {
//      super.init(frame: frame)
//      setDarkModeBackground()
//    }
//    
//    required init(coder: NSCoder) {
//      super.init(coder: coder)!
//      setDarkModeBackground()
//    }
//    
//    func setDarkModeBackground(){
//      if #available(iOS 11.0, *) {
//        self.setTitleColor(UIColor(named: "Black_Light_DarkTheme"), for: .normal)
//      } else {
//        // Fallback on earlier versions
//      }
//    }
//}

