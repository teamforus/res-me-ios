//
//  SuccesCreateRecordViewController.swift
//  Me-iOS
//
//  Created by Inga Codreanu on 25.06.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MSuccessCreateRecordViewController: UIViewController {
    @IBOutlet weak var recordTypeLabel: UILabel!
    @IBOutlet weak var recordValueLabel: UILabel!
    
    var recordType: RecordType!
    var value: String!
    
    var completedCreateRecord: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupRecord() {
        recordTypeLabel.text = recordType.name
        recordValueLabel.text = value
    }
    
    @IBAction func next(_ sender: Any) {
        completedCreateRecord?()
    }
}
