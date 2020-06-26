//
//  MChooseTypeRecordViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/29/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import KVSpinnerView

class MChooseTypeRecordViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var chooseTypeCompleted: ((RecordType)->())?
    
    lazy var chooseTypeRecordVM: ChooseTypeRecordViewModel = {
        return ChooseTypeRecordViewModel()
    }()
    var selectedCell: [Int]! = []
    var previousCell: MChooseTypeTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseTypeRecordVM.reloadDataTableView = { [weak self] in
            
            DispatchQueue.main.async {
                
                KVSpinnerView.dismiss()
                self?.tableView.reloadData()
            }
        }
        
        if isReachable() {
            
            KVSpinnerView.show()
            chooseTypeRecordVM.initFetch()
            
        }else {
            
            showInternetUnable()
            
        }
        
    }
}

extension MChooseTypeRecordViewController: BWWalkthroughPage {
    
    func walkthroughDidScroll(to: CGFloat, offset: CGFloat) {
        
    }
}

extension MChooseTypeRecordViewController: MChooseTypeTableViewCellDelegate {
    
    func chooseType(cell: MChooseTypeTableViewCell) {
        if previousCell != nil {
            previousCell.viewTypeRecord.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
            previousCell.checkBox.isSelected = false
            
            if let index = selectedCell.firstIndex(of: cell.tag) {
                selectedCell.remove(at: index)
            }
        }
        if previousCell != cell {
            cell.viewTypeRecord.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9725490196, alpha: 1)
            cell.checkBox.isSelected = true
            selectedCell.append(cell.tag)
        }
        previousCell = cell
        let recordType = chooseTypeRecordVM.getCellViewModel(at: IndexPath(row: cell.tag, section: 0))
        self.chooseTypeCompleted?(recordType)
        NotificationCenter.default.post(name: NotificationName.EnableNextButton, object: nil)
    }
    
}

extension MChooseTypeRecordViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chooseTypeRecordVM.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MChooseTypeTableViewCell
        
        cell.recordType = chooseTypeRecordVM.getCellViewModel(at: indexPath)
        cell.delegate = self
        cell.tag = indexPath.row
        
        if selectedCell.contains(indexPath.row){
            cell.viewTypeRecord.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9725490196, alpha: 1)
            cell.checkBox.isSelected = true
        }else{
            cell.viewTypeRecord.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
            cell.checkBox.isSelected = false
        }
        
        return cell
    }
}


