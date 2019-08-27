//
//  MRecordValidatorsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/28/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MRecordValidatorsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryRecordLabel: UILabel!
    @IBOutlet weak var typeRecordLabel: ShadowButton!
    @IBOutlet weak var recordValueLabel: ShadowButton!
    
    
    var record: Record!
    lazy var recordValidatorViewModel: RecordValidatorsViewModel = {
        return RecordValidatorsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryRecordLabel.text = "Personal".localized()
        self.typeRecordLabel.setTitle(record.name ?? "", for: .normal)
        self.recordValueLabel.setTitle(record.value, for: .normal)
        
        recordValidatorViewModel.reloadDataTableView = { [weak self] in
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }
        
        recordValidatorViewModel.confirValidation = { [weak self] (statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode == 201 {
                    
                    self?.showSimpleAlert(title: "Validation", message: "Record is validated.")
                    
                } else {
                    
                    self?.showSimpleAlert(title: "Validation", message: "This validator has already validated this record.")
                    
                }
            }
            
        }
        
        if isReachable() {
            
            recordValidatorViewModel.initFecth()
            
        }else {
            
            showInternetUnable()
            
        }
        
    }
    
}

extension MRecordValidatorsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordValidatorViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ValidatorTableViewCell
        
        cell.validator = recordValidatorViewModel.getCellViewModel(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.recordValidatorViewModel.userPressed(at: indexPath)
        let validator = self.recordValidatorViewModel.selectedValidator
        
        if isReachable() {
            
            self.recordValidatorViewModel.initValidateRecord(validatorId: validator?.id ?? 0, recordId: record.id ?? 0)
            
        }else {
            
            showInternetUnable()
            
        }
        
    }
}
