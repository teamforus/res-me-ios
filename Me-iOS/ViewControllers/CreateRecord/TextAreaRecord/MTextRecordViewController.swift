//
//  MTextRecordViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/29/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import KVSpinnerView

class MTextRecordViewController: UIViewController {
    @IBOutlet weak var textUITextView: UITextView!
    @IBOutlet weak var selectedCategory: ShadowButton!
    @IBOutlet weak var selectedType: ShadowButton!
    @IBOutlet weak var clearUIButton: UIButton!
    
    var recordCreated:((RecordType, String)->())?
    
    var recordType: RecordType!
    lazy var textRecordViewModel: TextRecordViewModel = {
        return TextRecordViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        
        textRecordViewModel.complete = { [weak self] (statusCode) in
            DispatchQueue.main.async {
                
                guard let self = self else { return}
                
                KVSpinnerView.dismiss()
                if statusCode == 401 {
                    
                    self.showSimpleAlert(title: "Warning", message: "Something goes wrong please try again!")
                    
                }else {
                    self.recordCreated?(self.recordType, self.textUITextView.text ?? "")
                    
                }
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setSelectedCategoryType(){
        selectedType.setTitle(self.recordType?.name, for: .normal)
        if self.recordType.type == "number" {
            self.textUITextView.keyboardType = .numberPad
        }
        
        if (self.recordType.name?.contains("E-mail"))!{
            self.textUITextView.keyboardType = .emailAddress
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
                showSimpleAlert(title: "Warning", message: "Please fill textarea.")
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
