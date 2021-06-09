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
    var lastPage: Int?
    var currentPage: Int?
    var nextPage: String?
    
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
        let request = (lastPage == currentPage ? "platform/provider/vouchers/" + voucherAddress + "/products" : nextPage?.replacingOccurrences(of: "https://staging.api.forus.io/api/v1/", with: "")) ?? ""
        commonService.get(request: request, complete: { (response: ResponseDataArray<Subsidie>, statusCode) in
            self.processFetchedLunche(subsidies: response.data ?? [])
            self.lastPage = response.meta?.last_page ?? 0
            self.currentPage = response.meta?.current_page ?? 0
            self.nextPage = response.links?.next ?? ""
        }) { (error) in
            
        }
    }
    
    func createCellViewModel( subsidie: Subsidie ) -> Subsidie {
        
        return subsidie
    }
    
    private func processFetchedLunche( subsidies: [Subsidie] ) {
        var vms = [Subsidie]()
        for subsidie in subsidies {
            vms.append( createCellViewModel(subsidie: subsidie))
        }
        vms.forEach { (subsidie) in
            self.cellViewModels.append(subsidie)
        }
    }
}
