//
//  TextRecordViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/29/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation


class TextRecordViewModel {
    
    var commonService: CommonServiceProtocol!
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    var complete: ((Int)->())?
    
    func initCreateRecord(type: String, value: String){
        
        let parameters = [ "type" : type,
                           "value" : value]
        
        commonService.postWithParameters(request: "identity/records", parameters: parameters, complete: { (response: Record, statusCode) in
            self.complete?(statusCode)
        }) { (error) in
            
        }
    }
}
