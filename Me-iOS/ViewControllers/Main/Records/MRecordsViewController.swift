//
//  MRecordsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import BWWalkthrough
import KVSpinnerView

class MRecordsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var newRecordButton: ShadowButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
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
                
                self?.tableView.reloadData()
                KVSpinnerView.dismiss()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func createRecord(_ sender: UIButton) {
        
        var stb = UIStoryboard(name: "ChooseTypeRecord", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let pageOne = stb.instantiateViewController(withIdentifier: "types")
        stb = UIStoryboard(name: "TextRecord", bundle: nil)
        let pageTwo = stb.instantiateViewController(withIdentifier: "text")
        
        walkthrough.delegate = self
        walkthrough.scrollview.isScrollEnabled = false
        walkthrough.add(viewController:pageOne)
        walkthrough.add(viewController:pageTwo)
        
        self.present(walkthrough, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initFetch()
        if #available(iOS 13, *) {
        }else {
            self.setStatusBarStyle(.default)
        }
        self.tabBarController?.set(visible: true, animated: true)
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
        
        if segue.identifier == "goToRecordDetail" {
            
            let record = recordViewModel.selectedRecord
            let generalVC = didSetPullUP(storyBoardName: "RecordDetail", segue: segue)
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
        
        #if ALPHA
        
        self.recordViewModel.userPressed(at: indexPath)
        if recordViewModel.isAllowSegue {
            return indexPath
        }else {
            return nil
        }
        
        #else
        
        return nil
        
        #endif
        
        
    }
}

