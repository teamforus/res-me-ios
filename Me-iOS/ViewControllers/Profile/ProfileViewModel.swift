//
//  ProfileViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 6/6/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit


class ProfileViewModel {
    
    var commonService: CommonServiceProtocol!
    var vc: UIViewController!
    
    var complete: ((String, String)->())?
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    func initProfile(){
        
        commonService.get(request: "identity", complete: { (response: Identity, statusCode) in
            if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            } else {
               
                
                self.complete?(response.email ?? "", response.address ?? "")
            }
            
        }) { (error) in
            
        }
        
    }
    
}
