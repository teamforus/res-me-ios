//
//  ActionViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 04.09.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import Foundation

class ActionViewModel {
    var commonService: CommonServiceProtocol!
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    private var cellViewModels: [Subsidie] = [Subsidie]() {
        didSet {
            complete?(cellViewModels)
        }
    }
    
    var complete: (([Subsidie])->())?
    
    func fetchSubsidies(voucherAddress: String) {
        commonService.get(request: "platform/provider/vouchers/" + voucherAddress + "/products", complete: { (response: ResponseDataArray<Subsidie>, statusCode) in
            self.processFetchedLunche(subsidies: response.data ?? [])
        }) { (error) in
            
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> Subsidie {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( subsidie: Subsidie ) -> Subsidie {
        
        return subsidie
    }
    
    private func processFetchedLunche( subsidies: [Subsidie] ) {
        var vms = [Subsidie]()
        for subsidie in subsidies {
            vms.append( createCellViewModel(subsidie: subsidie))
        }
        self.cellViewModels = vms
    }
}
