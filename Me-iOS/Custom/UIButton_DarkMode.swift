//
//  UIbutton_DarkMode.swift
//  Me-iOS
//
//  Created by mac on 7/21/20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class UIButton_DarkMode: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setDarkModeButton()
  }
  
  @IBInspectable var colorName :String = "Background_DarkTheme" {
    didSet {
      setSelectedColorName()
    }
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)!
    setDarkModeButton()
  }
  
  func setDarkModeButton(){
    let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
    self.setImage(image, for: .normal)
    if #available(iOS 11.0, *) {
      self.tintColor = UIColor(named: "Background_DarkTheme")
    } else {
      // Fallback on earlier versions
    }
  }
  
  func setSelectedColorName() {
    if #available(iOS 11.0, *) {
      self.backgroundColor = UIColor(named: colorName)
    } else {
      // Fallback on earlier versions
    }
  }
  
}

class UIButtonShadow_DarkMode: ShadowButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setDarkModeButton()
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
    setDarkModeButton()
  }
  
//  @IBInspectable override var colorNameTitle :String = "Background_DarkTheme" {
//    didSet {
//      setSelectedColorNameTitle()
//     }
//  }
//  
  func setDarkModeButton(){
    if #available(iOS 11.0, *) {
      self.tintColor = UIColor(named: "Gray_Light_DarkTheme")
    } else {
      // Fallback on earlier versions
    }
  }
  
  func setSelectedColorNameTitle() {
    if #available(iOS 11.0, *) {
      self.setTitleColor(UIColor(named: colorNameTitle), for: .normal)
    } else {
      // Fallback on earlier versions
    }
  }
  
}

class  UIButtonBackground_DarkMode: UIButton{
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setDarkModeButton()
  }
  
  @IBInspectable var colorName :String = "Background_DarkTheme" {
    didSet {
      setSelectedColorName()
      
    }
  }
  
  
  
  required init(coder: NSCoder) {
    super.init(coder: coder)!
    setDarkModeButton()
  }
  
  func setDarkModeButton(){
    
    //self.setImage(image, for: .normal)
    if #available(iOS 11.0, *) {
      self.tintColor = UIColor(named: "Background_DarkTheme")
    } else {
      // Fallback on earlier versions
    }
  }
  
  func setSelectedColorName() {
    if #available(iOS 11.0, *) {
      self.backgroundColor = UIColor(named: colorName)
    } else {
      // Fallback on earlier versions
    }
  }
  
  
}
