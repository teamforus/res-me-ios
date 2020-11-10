//
//  MTextRecordViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/29/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class MTextRecordViewController: UIViewController {
    @IBOutlet weak var textUITextView: UITextView!
    @IBOutlet weak var selectedCategory: ShadowButton!
    @IBOutlet weak var selectedType: ShadowButton!
    @IBOutlet weak var clearUIButton: UIButton!
    
    
    var recordType: RecordType!
    lazy var textRecordViewModel: TextRecordViewModel = {
        return TextRecordViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(setSelectedCategoryType), name: NotificationName.SelectedCategoryType, object: nil)
        
        textRecordViewModel.complete = { [weak self] (statusCode) in
            DispatchQueue.main.async {
                
                KVSpinnerView.dismiss()
                if statusCode == 401 {
                    
                    self?.showSimpleAlert(title: Localize.warning(), message: "Something goes wrong please try again!")
                    
                }else {
                    
                    NotificationCenter.default.post(name: NotificationName.ClosePageControll, object: nil)
                    
                }
            }
        }
        
    }
    
    @objc func setSelectedCategoryType(){
        
        if let recordType = UserDefaults.standard.value(forKey: "type") as? NSData {
            self.recordType = try? PropertyListDecoder().decode(RecordType.self, from: recordType as Data)
            selectedType.setTitle(self.recordType?.name, for: .normal)
            if self.recordType.type == "number" {
                self.textUITextView.keyboardType = .numberPad
            }
            
            if (self.recordType.name?.contains("E-mail"))!{
                self.textUITextView.keyboardType = .emailAddress
            }
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        textUITextView.text = ""
        textUITextView.becomeFirstResponder()
    }
    
    @IBAction func createRecord(_ sender: UIButton) {
        
        if isReachable() {
            
            if textUITextView.text != "" {
                KVSpinnerView.show()
                textRecordViewModel.initCreateRecord(type: recordType.key ?? "", value: textUITextView.text)
                
            }else {
                showSimpleAlert(title: Localize.warning(), message: "Please fill textarea.")
            }
            
        }else {
            
            showInternetUnable()
            
        }
        
    }
    
    
    
}

extension MTextRecordViewController: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count != 0{
            clearUIButton.isHidden = false
        }else {
            clearUIButton.isHidden = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textUITextView.text = ""
    }
}
