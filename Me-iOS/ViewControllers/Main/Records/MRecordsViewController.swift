//
//  MRecordsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import BWWalkthrough
class MRecordsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var newRecordButton: ShadowButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var titileLabel: UILabel_DarkMode!
  
    
    lazy var recordViewModel: RecordsViewModel = {
        return RecordsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(walkthroughCloseButtonPressed), name: NotificationName.ClosePageControll, object: nil)
        setupRefreshContorl()
        setupCompletion()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupView() {
        #if ALPHA
        newRecordButton.isHidden = false
        topConstraint.constant = 207
        
        #else
        topConstraint.constant = 140
        newRecordButton.isHidden = true
        #endif
    }
    
    func setupCompletion() {
        recordViewModel.complete = { [weak self] (records) in
            
            DispatchQueue.main.async {
                
                self?.tableView.reloadData()
                KVSpinnerView.dismiss()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    func setupRefreshContorl() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @IBAction func createRecord(_ sender: UIButton) {
        
        if let walkthrough = R.storyboard.chooseTypeRecord.walk() {
            walkthrough.delegate = self
            walkthrough.scrollview.isScrollEnabled = false
            
            if let pageOne = R.storyboard.chooseTypeRecord.types() {
                walkthrough.add(viewController:pageOne)
            }
            
            if let pageTwo = R.storyboard.textRecord.text() {
                walkthrough.add(viewController:pageTwo)
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
        if pageNumber == 3{
            NotificationCenter.default.post(name: Notification.Name("HidePageNumber"), object: nil)
        }
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
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
  func setupAccessibility() {
    titileLabel.setupAccesibility(description: Localize.personal(), accessibilityTraits: .header)
    }
}

