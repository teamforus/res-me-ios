//
//  MRecordDetailViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import KVSpinnerView

class MRecordDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recordTypeLabel: UILabel!
    @IBOutlet weak var recordValue: UILabel!
    @IBOutlet weak var borderView: CustomCornerUIView!
  
    var recordId: String!
    var timer : Timer! = Timer()
    var record: Record!
    lazy var recordDetailViewModel: RecordDetailViewModel = {
        return RecordDetailViewModel()
    }()
    private lazy var qrViewModel: QRViewModel = {
        return QRViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordDetailViewModel.vc = self
        fetchRecordDetail()
        completeDelete()
        setupTimer()
    }
    
    deinit {
        self.timer.invalidate()
        self.timer = nil
    }
    
    func setupTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(self.checkRecordValidateState), userInfo: nil, repeats: true)
    }
    
    @objc func checkRecordValidateState() {
        fetchRecordValidationState()
    }
    
    func fetchRecordValidationState() {
        if let recordValue = UserDefaults.standard.string(forKey: UserDefaultsName.CurrentRecordUUID) {
            self.qrViewModel.initValidationRecord(code: recordValue)
        }
        
        qrViewModel.validateRecord = { [weak self] (recordValidation, statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode != 503 {
                    if recordValidation.state == "approved" {
                        self?.showSimpleAlert(title: Localize.success(), message: Localize.validation_approved())
                    }
                }else {
                }
            }
        }
    }
    
    func fetchRecordDetail() {
        recordDetailViewModel.complete = { [weak self] (record) in
            
            DispatchQueue.main.async {
                
                self?.record = record
                
                self?.recordTypeLabel.text = record.name ?? ""
                self?.recordValue.text = record.value
                self?.tableView.reloadData()
                
                if self?.recordDetailViewModel.numberOfCells == 0{
                    
                    self?.tableView.isHidden = true
                    
                }else {
                    
                    self?.tableView.isHidden = false
                    
                }
                KVSpinnerView.dismiss()
            }
        }
        
        
        if isReachable() {
            
            KVSpinnerView.show()
            recordDetailViewModel.initFetchById(id: recordId)
            
        }else {
            
            showInternetUnable()
            
        }
    }
    
    func completeDelete() {
        recordDetailViewModel.completeDelete = { [weak self] (statusCode) in
            
            DispatchQueue.main.async {
                
                KVSpinnerView.dismiss()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
  
    @IBAction func showQRCode(_ sender: Any) {
        let popOverVC = PullUpQRViewController(nib: R.nib.pullUpQRViewController)
        popOverVC.idRecord = Int(recordId)
        popOverVC.record = record
        popOverVC.qrType = .Record
        showPopUPWithAnimation(vc: popOverVC)
    }
    
    @IBAction func deleteRecord(_ sender: UIButton) {
      let popUp = CustomWarningViewController(title: Localize.you_like_to_archive_record(), descriptions:Localize.description_to_archive_record(), buttonTitle: Localize.archive_button())
      showPopUPWithAnimation(vc: popUp)
      popUp.confirm = { [weak self] in
        guard let self = self else {
          return
        }
        DispatchQueue.main.async {
          KVSpinnerView.show()
          self.recordDetailViewModel.initDeleteById(id: self.recordId)
        }
      }
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recordValidatorVC = segue.destination as? MRecordValidatorsViewController {
            recordValidatorVC.record = self.record
        }
    }
}
extension MRecordDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordDetailViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ValidatorTableViewCell
        
        cell.validator = recordDetailViewModel.getCellViewModel(at: indexPath)
        
        return cell
    }
}
