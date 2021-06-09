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
  
    var dataSource: RecordsDataSource!
    
    lazy var recordViewModel: RecordsViewModel = {
        return RecordsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if ALPHA
        newRecordButton.isHidden = false
        topConstraint.constant = 207
        
        #else
        topConstraint.constant = 140
        newRecordButton.isHidden = true
        #endif
        
        NotificationCenter.default.addObserver(self, selector: #selector(walkthroughCloseButtonPressed), name: NotificationName.ClosePageControll, object: nil)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        recordViewModel.complete = { [weak self] (records) in
            
            DispatchQueue.main.async {
                self?.dataSource = RecordsDataSource(records: records)
                self?.tableView.dataSource = self?.dataSource
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
        if let recordVC = segue.destination as? MRecordDetailViewController {
            let record = self.dataSource.records[tableView.indexPathForSelectedRow?.row ?? 0]
            recordVC.recordId = String(record.id ?? 0)
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

extension MRecordsViewController {
  func setupAccessibility() {
    titileLabel.setupAccesibility(description: Localize.personal(), accessibilityTraits: .header)
    }
}

