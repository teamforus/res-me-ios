//
//  MRecordDetailViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/27/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MRecordDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recordTypeLabel: UILabel!
    @IBOutlet weak var recordValue: UILabel!
    @IBOutlet weak var borderView: CustomCornerUIView!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            
        }
        
        let backButton = UIBarButtonItem(image: R.image.back(), style: .plain, target: self, action: #selector(back(_:)))
        if #available(iOS 11.0, *) {
            backButton.tintColor = UIColor(named: "Black_Light_DarkTheme")
        } else { }
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = Localize.record_detail()
    }
    
    deinit {
        self.timer.invalidate()
        self.timer = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
                    self?.heightTableViewConstraint.constant = CGFloat(self?.recordDetailViewModel.numberOfCells ?? 0) * 116
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
        KVSpinnerView.show()
        recordDetailViewModel.initDeleteById(id: recordId)
        
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
