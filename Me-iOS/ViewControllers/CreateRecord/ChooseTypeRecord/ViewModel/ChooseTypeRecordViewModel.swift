//
//  ChooseTypeRecordViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/29/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation

class ChooseTypeRecordViewModel {
    
    var commonService: CommonServiceProtocol!
    var selectedValidator: RecordType?
    var isAllowSegue: Bool = false
    private var cellViewModels: [RecordType] = [RecordType]() {
        didSet{
            self.reloadDataTableView?()
        }
    }
    
    var reloadDataTableView: (()->())?
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    func initFetch(){
        
        self.commonService.get(request: "identity/record-types", complete: { (response: [RecordType], statusCode) in
            
            self.processFetchedLunche(recordTypes: response )
            
        }) { (error) in
            
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> RecordType {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( recordType: RecordType ) -> RecordType {
        
        return recordType
    }
    
    private func processFetchedLunche( recordTypes: [RecordType] ) {
        var vms = [RecordType]()
        for recordType in recordTypes {
            
            vms.append( createCellViewModel(recordType: recordType) )
        }
        
        self.cellViewModels = vms
    }
}

extension ChooseTypeRecordViewModel {
    
    func userPressed( at indexPath: IndexPath) {
        let recordType = self.cellViewModels[indexPath.row]
        self.isAllowSegue = true
        self.selectedValidator = recordType
    }
}
