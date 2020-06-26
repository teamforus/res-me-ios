//
//  MRecordsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import KVSpinnerView

class MRecordsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var newRecordButton: ShadowButton!
    
    var walthroughViewController: BWWalkthroughViewController!
    
    
    lazy var recordViewModel: RecordsViewModel = {
        return RecordsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(walkthroughCloseButtonPressed), name: NotificationName.ClosePageControll, object: nil)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        recordViewModel.complete = { [weak self] (records) in
            
            DispatchQueue.main.async {
                
                self?.tableView.reloadData()
                KVSpinnerView.dismiss()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func createRecord(_ sender: UIButton) {
        
        if let walkthrough = R.storyboard.chooseTypeRecord.walk() {
            walkthrough.delegate = self
            walkthrough.scrollview.isScrollEnabled = false
            walthroughViewController = walkthrough
            
            guard let chooseTypeRecordController = R.storyboard.chooseTypeRecord.types(), let textRecordController = R.storyboard.textRecord.text(), let successRecordController = R.storyboard.successCreateRecord.successCreateRecord() else {
                return
            }
            
            walkthrough.add(viewController: chooseTypeRecordController)
            walkthrough.add(viewController: textRecordController)
            walkthrough.add(viewController: successRecordController)
            
            chooseTypeRecordController.chooseTypeCompleted = {  [weak self] (recordType) in
                DispatchQueue.main.async {
                    textRecordController.recordType = recordType
                    self?.walthroughViewController.nextButton?.tintColor = #colorLiteral(red: 0.1903552711, green: 0.369412154, blue: 0.9929068685, alpha: 1)
                    self?.walthroughViewController.nextButton?.isEnabled = true
                    self?.walthroughViewController.nextButton?.setTitleColor(#colorLiteral(red: 0.1903552711, green: 0.369412154, blue: 0.9929068685, alpha: 1), for: .normal)
                    textRecordController.setSelectedCategoryType()
                }
            }
            textRecordController.recordCreated = { [weak self] (recordType, value) in
                DispatchQueue.main.async {
                    successRecordController.recordType = recordType
                    successRecordController.value = value
                    successRecordController.setupRecord()
                    self?.walthroughViewController.prevButton?.isHidden = true
                    self?.walthroughViewController.nextButton?.isHidden = true
                    walkthrough.nextPage()
                }
            }
            
            successRecordController.completedCreateRecord = { [weak self] () in
                self?.dismiss(animated: true) {
                    self?.initFetch()
                }
            }
            
            self.present(walkthrough, animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initFetch()
        if #available(iOS 13, *) {
        }else {
            self.setStatusBarStyle(.default)
        }
    }
    
    func initFetch() {
        if isReachable() {
            KVSpinnerView.show()
            recordViewModel.vc = self
            recordViewModel.initFitch()
            
        }else {
            
            showInternetUnable()
            
        }
    }
    
    @objc func refreshData(_ sender: Any) {
        initFetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = R.segue.mRecordsViewController.goToRecordDetail(segue: segue) {
            let record = recordViewModel.selectedRecord
            let generalVC = didSetPullUP(storyboard: R.storyboard.recordDetail(), segue: segue)
            (generalVC.contentViewController as! MRecordDetailViewController).recordId =  String(record?.id ?? 0)
            (generalVC.bottomViewController as! CommonBottomViewController).qrType = .Record
            (generalVC.bottomViewController as! CommonBottomViewController).idRecord = record?.id ?? 0
        }
    }
}

extension MRecordsViewController: BWWalkthroughViewControllerDelegate{
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        if pageNumber == 0 {
            walthroughViewController.prevButton?.isHidden = true
            walthroughViewController.nextButton?.isHidden = false
        } else if pageNumber == 1 {
            walthroughViewController.prevButton?.isHidden = false
            walthroughViewController.nextButton?.isHidden = true
        }
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true) {
            self.initFetch()
        }
    }
}

extension MRecordsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecordsTableViewCell
        
        cell.record = recordViewModel.getCellViewModel(at: indexPath)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        self.recordViewModel.userPressed(at: indexPath)
        if recordViewModel.isAllowSegue {
            return indexPath
        }else {
            return nil
        }
    }
}

