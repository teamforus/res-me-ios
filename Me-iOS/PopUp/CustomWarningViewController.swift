//
//  CustomWarningViewController.swift
//  Me-iOS
//
//  Created by Daniel Tcacenco  on 26.06.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit



class CustomWarningViewController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  var buttonTitle:String!
  var titleString: String!
  var descriptions: String!
  @IBOutlet weak var confirmButton: ShadowButton!
  
  var confirm:(()->())?
  var cancel:(()->())?
  
  init(title:String,descriptions:String,buttonTitle:String) {
    super.init(nibName: "CustomWarningViewController", bundle: nil)
    self.titleString = title
    self.descriptions = descriptions
    self.buttonTitle = buttonTitle
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setUpView(){
    self.titleLabel.text = self.titleString
    self.descriptionLabel.text = self.descriptions
    self.confirmButton.setTitle(self.buttonTitle, for: .normal)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpView()
    showAnimate()
  }
  
  @IBAction func confirm(_ sender: Any) {
    confirm?()
  }
  
  @IBAction func cancel(_ sender: Any) {
    removeAnimate()
  }
}
