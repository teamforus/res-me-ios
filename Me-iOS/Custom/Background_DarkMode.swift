//
//  Background_DarkMode.swift
//  Me-iOS
//
//  Created by mac on 7/15/20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class Background_DarkMode: UIView {
    
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

class TableView_Background_DarkMode: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setDarkModeBackground()
    }
  @IBInspectable var colorName :String = "WhiteBackground_DarkTheme" {
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
        self.backgroundColor = UIColor(named: "WhiteBackground_DarkTheme")
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
