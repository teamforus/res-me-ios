//
//  RecordsViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation
import UIKit
class RecordsViewModel{
    
    var commonService: CommonServiceProtocol!
    var vc: UIViewController!
    
    var complete: (([Record])->())?
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    func initFitch(){
        
        commonService.get(request: "identity/records", complete: { (response: [Record], statusCode) in
            if statusCode == 503 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                }
                self.vc.showErrorServer()
                
            }else if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                }
                
                self.complete?(response)
            }
        }) { (error) in
            DispatchQueue.main.async {
                KVSpinnerView.dismiss()
            }
        }
    }
}
