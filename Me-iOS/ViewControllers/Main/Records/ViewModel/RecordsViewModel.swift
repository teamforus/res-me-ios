//
//  RecordsViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation
import UIKit
import KVSpinnerView

class RecordsViewModel{
    
    var commonService: CommonServiceProtocol!
    var selectedRecord: Record?
    var isAllowSegue: Bool = false
    var vc: UIViewController!
    var isArchived: Bool = false
    
    private var cellViewModels: [Record] = [Record]() {
        didSet {
            complete?(cellViewModels)
        }
    }
    
    var complete: (([Record])->())?
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    func initFitch(){
        let request = isArchived ? "identity/records?deleted=1" : "identity/records"
        
        commonService.get(request: request, complete: { (response: [Record], statusCode) in
            if statusCode == 503 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                }
                self.vc.showErrorServer()
                
            }else if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: "Expired session".localized(), message: "Your session has expired. You are being logged out.".localized() , okAction: UIAlertAction(title: "Log out".localized(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                }
                
                self.processFetchedLunche(records: response)
            }
            
            
            
        }) { (error) in
            
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> Record {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( record: Record ) -> Record {
        
        return record
    }
    
    private func processFetchedLunche( records: [Record] ) {
        var vms = [Record]()
        for record in records {
            
            vms.append( createCellViewModel(record: record) )
        }
        self.cellViewModels = vms
    }
}


extension RecordsViewModel {
    
    func userPressed( at indexPath: IndexPath) {
        let record = self.cellViewModels[indexPath.row]
        self.isAllowSegue = true
        self.selectedRecord = record
    }
}
