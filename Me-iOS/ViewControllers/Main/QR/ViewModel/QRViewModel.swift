//
//  QRViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation
import UIKit
import KVSpinnerView

class QRViewModel{
    
    var commonService: CommonServiceProtocol!
    var vc: MQRViewController!
    var authorizeToken: ((Int)->())!
    var vcAlert: UIViewController!
    
    var validateRecord: ((RecordValidation, Int)->())!
    var validateApproveRecord: ((Int)->())!
    
    var getVoucher: ((Voucher, Int)->())!
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    
    func initAuthorizeToken(token: String) {
        let parameters = ["auth_token" : token]
        
        commonService.postWithParameters(request: "identity/proxy/authorize/token", parameters: parameters, complete: { (response: AuthorizationQRToken, statusCode) in
            self.authorizeToken?(statusCode)
        }) { (error) in
            
            
            
        }
        
    }
    
    
    func initVoucherAddress(address: String) {
        
        commonService.get(request: "platform/vouchers/"+address+"/provider", complete: { (response: ResponseData<Voucher>, statusCode) in
            
            if statusCode == 500 {
                
                DispatchQueue.main.async {
                    
                    KVSpinnerView.dismiss()
                    self.vcAlert.showSimpleAlertWithSingleAction(title: "Warning".localized(), message: "This voucher is expired.", okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.vc?.scanWorker.start()
                    }))
                }
                
            }else if statusCode == 403  {
                DispatchQueue.main.async {
                    
                    KVSpinnerView.dismiss()
                    self.vcAlert.showSimpleAlertWithSingleAction(title: "Error!".localized(), message: response.message ?? "", okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.vc?.scanWorker.start()
                    }))
                }
            }else if statusCode == 404 {
                KVSpinnerView.dismiss()
                self.vcAlert.showSimpleAlertWithSingleAction(title: "Error!".localized(), message: response.message ?? "", okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.vc?.scanWorker.start()
                }))
                
                
            }else {
                self.getVoucher(response.data!, statusCode)
            }
        }) { (error) in
            KVSpinnerView.dismiss()
            self.vc.scanWorker.start()
        }
        
    }
    
    
    func initValidationRecord(code: String) {
        
        commonService.get(request: "identity/record-validations/" + code, complete: { (response: RecordValidation, statusCode) in
            
            self.validateRecord(response, statusCode)
            
        }) { (error) in
            
        }
        
    }
    
    func initApproveValidationRecord(code: String) {
        
        commonService.get(request: "identity/record-validations/" + code + "/approve", complete: { (response: AuthorizationQRToken, statusCode) in
            
            self.validateApproveRecord(statusCode)
            
        }) { (error) in
            
        }
    }
}
