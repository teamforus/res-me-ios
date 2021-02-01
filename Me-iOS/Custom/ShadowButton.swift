//
//  ShadowButton.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/12/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowButton: UIButton {
  
  @IBInspectable var colorName :String = "Background_DarkTheme" {
    didSet {
      setSelectedColorName()
    }
  }
  
  @IBInspectable var colorNameTitle :String = "Background_DarkTheme" {
    didSet {
      setSelectedTitileName()
    }
  }
  
  @IBInspectable var selectedShadowColor : UIColor = UIColor.black {
    didSet {
      setSelectShadowColor()
    }
  }
  
  @IBInspectable var cornerRadius : CGFloat = 0 {
    didSet {
      setCornerRadius()
    }
  }
  
  @IBInspectable var shadowOffset : CGSize = CGSize(width: 0, height: 0) {
    didSet {
      setShadowOffset()
    }
  }
  
  @IBInspectable var shadowOpacity : Float = 0 {
    didSet {
      setShadowOpacity()
    }
  }
  
  @IBInspectable var shadowRadius : CGFloat = 0 {
    didSet {
      setShadowRadius()
    }
  }
  
  @IBInspectable var borderColor :UIColor = UIColor.black {
    didSet {
      setSelectBorderColor()
    }
  }
  
  @IBInspectable var borderWidth : CGFloat = 0 {
    didSet {
      setBorderWidth()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.masksToBounds = false
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)!
    self.layer.masksToBounds = false
  }
  
  func setCornerRadius(){
    self.layer.cornerRadius = cornerRadius
  }
  
  func setSelectShadowColor(){
    self.layer.shadowColor = selectedShadowColor.cgColor
  }
  
  func setSelectBorderColor(){
    self.layer.borderColor = borderColor.cgColor
  }
  
  func setShadowOffset(){
    self.layer.shadowOffset = shadowOffset
  }
  
  func setShadowOpacity(){
    self.layer.shadowOpacity = shadowOpacity
  }
  
  func setShadowRadius(){
    self.layer.shadowRadius = shadowRadius
  }
  
  func setBorderWidth(){
    self.layer.borderWidth = borderWidth
  }
  func setSelectedColorName() {
    if #available(iOS 11.0, *) {
      self.backgroundColor = UIColor(named: colorName)
    } else {
      // Fallback on earlier versions
    }
  }
  func setSelectedTitileName() {
    if #available(iOS 11.0, *) {
      self.setTitleColor(UIColor(named: colorNameTitle), for: .normal)
    } else {
      self.setTitleColor(#colorLiteral(red: 0.307592541, green: 0.4586808085, blue: 0.9869144559, alpha: 1), for: .normal)
    }
  }
  
}
