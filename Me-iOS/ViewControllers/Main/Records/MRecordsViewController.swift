//
//  MRecordsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import KVSpinnerView
import HMSegmentedControl

enum RecordsListType: String, CaseIterable {
    case myRecords = "my_records"
    case archive = "archive"
}

class MRecordsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var newRecordButton: ShadowButton!
    @IBOutlet weak var segmentControll: HMSegmentedControl!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    var walthroughViewController: BWWalkthroughViewController!
    var recordTypeList: RecordsListType = .myRecords
    
    
    lazy var recordViewModel: RecordsViewModel = {
        return RecordsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(walkthroughCloseButtonPressed), name: NotificationName.ClosePageControll, object: nil)
        setupTableView()
        setupSegmentControl()
        completeFetchRecords()
    }
    
    func setupTableView() {
        tableView.register(MArchivedRecordTableViewCell.self, forCellReuseIdentifier: MArchivedRecordTableViewCell.indentifier)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    func setupSegmentControl() {
        let selectedColor = #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1)
        let normalColor = #colorLiteral(red: 0.3333011568, green: 0.3333538771, blue: 0.3332896829, alpha: 1)
        segmentControll.sectionTitles = RecordsListType.allCases.map({$0.rawValue.localized()})
        segmentControll.addTarget(self, action: #selector(segmentedControlChangedValue(segmentControl:)), for: .valueChanged)
        segmentControll.selectionIndicatorLocation = .bottom
        segmentControll.selectionIndicatorColor = selectedColor
        segmentControll.selectionIndicatorHeight = 2.0
        segmentControll.selectionStyle = .fullWidthStripe
        let font = UIFont(name: "GoogleSans-Medium", size: 14)!
        segmentControll.titleTextAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor:  normalColor]
        segmentControll.selectedTitleTextAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor:  selectedColor]
        
    }
    
    @objc func segmentedControlChangedValue(segmentControl: HMSegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            recordViewModel.isArchived = false
            recordTypeList = .myRecords
            newRecordButton.isHidden = false
            self.tabBarController?.tabBar.isHidden = false
            self.tableViewTopConstraint.constant = 1
            break
        case 1:
            recordViewModel.isArchived = true
            recordTypeList = .archive
            newRecordButton.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            tableViewTopConstraint.constant = 10
            break
        default:
            break
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        initFetchRecords()
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
            textRecordController.recordCreated = { [weak self] (record) in
                DispatchQueue.main.async {
                    successRecordController.record = record
                    successRecordController.setupRecord()
                    self?.walthroughViewController.prevButton?.isHidden = true
                    self?.walthroughViewController.nextButton?.isHidden = true
                    walkthrough.nextPage()
                }
            }
            
            successRecordController.completedCreateRecord = { [weak self] () in
                self?.dismiss(animated: true) {
                    self?.initFetchRecords()
                }
            }
            
            self.present(walkthrough, animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initFetchRecords()
        if #available(iOS 13, *) {
        }else {
            self.setStatusBarStyle(.default)
        }
    }
    
    func initFetchRecords() {
        if isReachable() {
            KVSpinnerView.show()
            recordViewModel.vc = self
            recordViewModel.initFitch()
            
        }else {
            
            showInternetUnable()
            
        }
    }
    
    func completeFetchRecords() {
        recordViewModel.complete = { [weak self] (records) in
            
            DispatchQueue.main.async {
                
                self?.tableView.reloadData()
                KVSpinnerView.dismiss()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func showArchivedRecords(_ sender: UIButton) {
        let archivedRecordsVC = MArchivedRecordsViewController()
        self.present(archivedRecordsVC, animated: true)
    }
    
    @objc func refreshData(_ sender: Any) {
        initFetchRecords()
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
            self.initFetchRecords()
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
        switch recordTypeList {
        case .myRecords:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecordsTableViewCell
            
            cell.record = recordViewModel.getCellViewModel(at: indexPath)
            
            return cell
        case .archive:
            let cell = tableView.dequeueReusableCell(withIdentifier: MArchivedRecordTableViewCell.indentifier, for: indexPath) as! MArchivedRecordTableViewCell
            cell.configure(record: recordViewModel.getCellViewModel(at: indexPath))
            
            return cell
        }
        
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

