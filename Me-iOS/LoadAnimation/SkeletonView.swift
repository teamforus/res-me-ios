//
//  SkeletonView.swift
//  SkeletonView
//
//  Created by Tcacenco Daniel on 5/16/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class SkeletonView: UILabel {
    
    var startLocations : [NSNumber] = [-1.0,-0.5, 0.0]
    var endLocations : [NSNumber] = [1.0,1.5, 2.0]
    
    var gradientBackgroundColor : CGColor =  #colorLiteral(red: 0.8974457979, green: 0.9088455439, blue: 0.9668905139, alpha: 1).cgColor
    var gradientMovingColor : CGColor = #colorLiteral(red: 0.6466326118, green: 0.649546802, blue: 0.7283003926, alpha: 1).cgColor
    
    
    var movingAnimationDuration : CFTimeInterval = 0.8
    var delayBetweenAnimationLoops : CFTimeInterval = 0.2
    
    
    var gradientLayer : CAGradientLayer!
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [
            gradientBackgroundColor,
            gradientMovingColor,
            gradientBackgroundColor
        ]
        
//        self.layer.cornerRadius = 12.0
        self.layer.masksToBounds = true
        gradientLayer.locations = self.startLocations
        self.layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }
    
   func setSelectedColorName() {
    if #available(iOS 11.0, *) {
      self.textColor = UIColor(named: colorName)
    } else {
      // Fallback on earlier versions
    }
  }
  
  @IBInspectable var colorName :String = "Background_DarkTheme" {
      didSet {
          setSelectedColorName()
      }
  }
    
    func startAnimating(){
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = self.startLocations
        animation.toValue = self.endLocations
        animation.duration = self.movingAnimationDuration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = self.movingAnimationDuration + self.delayBetweenAnimationLoops
        animationGroup.animations = [animation]
        animationGroup.repeatCount = .infinity
        self.gradientLayer.add(animationGroup, forKey: animation.keyPath)
    }
    
    func stopAnimating() {
        self.gradientLayer.removeAllAnimations()
        self.gradientLayer.removeFromSuperlayer()
    }
    
}
