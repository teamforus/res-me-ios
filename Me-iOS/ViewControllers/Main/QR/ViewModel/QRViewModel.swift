//
//  QRViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation
import UIKit

class QRViewModel{
    
    var commonService: CommonServiceProtocol!
    var vc: MQRViewController!
    var authorizeToken: ((Int)->())!
    var vcAlert: UIViewController!
    
    var validateRecord: ((RecordValidation, Int)->())!
    var validateApproveRecord: ((Int)->())!
    var completeTestToken: (()->())?
    
    var completeOrganization: (([EmployeesOrganization]) -> ())?
    
    var getVoucher: ((Voucher, Int)->())!
    var getProducts: (([Transaction])->())?
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    
    func initAuthorizeToken(token: String) {
        let parameters = ["auth_token" : token]
        
        commonService.postWithParameters(request: "identity/proxy/authorize/token", parameters: parameters, complete: { (response: AuthorizationQRToken, statusCode) in
            
            if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                
                self.authorizeToken?(statusCode)
            }
        }) { (error) in }
        
    }
    
    
    func initVoucherAddress(address: String) {
        
        commonService.get(request: "platform/provider/vouchers/"+address, complete: { (response: ResponseData<Voucher>, statusCode) in
            
            if statusCode == 500 {
                
                DispatchQueue.main.async {
                    
                    KVSpinnerView.dismiss()
                    self.vcAlert.showSimpleAlertWithSingleAction(title: Localize.warning(), message: "This voucher is expired.", okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                        self.vc?.scanWorker.start()
                    }))
                }
                
            }else if statusCode == 403  {
                DispatchQueue.main.async {
                    
                    KVSpinnerView.dismiss()
                    self.vcAlert.showSimpleAlertWithSingleAction(title:  Localize.error(), message: response.message ?? "", okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                        self.vc?.scanWorker.start()
                    }))
                }
            }else if statusCode == 404 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vcAlert.showSimpleAlertWithSingleAction(title: Localize.error(), message: response.message ?? "", okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                        self.vc?.scanWorker.start()
                    }))
                }
                
            }else if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                self.getVoucher(response.data!, statusCode)
            }
        }) { (error) in
            DispatchQueue.main.async {
                KVSpinnerView.dismiss()
                self.vc.scanWorker.start()
            }
        }
        
    }
    
    
    func iniProductsFromVoucher(address: String) {
        commonService.get(request: "platform/provider/vouchers/"+address+"/product-vouchers", complete: { (response: ResponseDataArray<Transaction>, statusCode) in
            
            if statusCode == 500 {
                
                
            }else if statusCode == 403  {
               
            }else if statusCode == 404 {
              
                
            }else if statusCode == 401 {
              
            }else {
                self.getProducts?(response.data ?? [])
            }
        }) { (error) in
            DispatchQueue.main.async {
                KVSpinnerView.dismiss()
                self.vc.scanWorker.start()
            }
        }
    }
    
    func initValidationRecord(code: String) {
        
        commonService.get(request: "identity/record-validations/" + code, complete: { (response: RecordValidation, statusCode) in
            if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            } else {
                self.validateRecord(response, statusCode)
            }
        }) { (error) in
            
        }
        
    }
    
    func getOrganizations(){
        commonService.get(request: "platform/employees?role=validation", complete: { (response: ResponseDataArray<EmployeesOrganization>, statusCode) in
             if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                self.completeOrganization?(response.data ?? [])
            }
        }) { (error) in
            
        }
    }
    
    func initApproveValidationRecord(code: String, organization: OrganizationRecord) {
        
        commonService.patch(request: "identity/record-validations/" + code + "/approve", data: organization) { (response: AuthorizationQRToken, statusCode) in
            if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                self.validateApproveRecord(statusCode)
            }
        }
    }
    
    func initTestTransaction() {
        
        commonService.get(request: "platform/demo/transactions/" +  CurrentSession.shared.token, complete: { (response: ResponseDataArray<EmployeesOrganization>, statusCode) in
            if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                self.completeTestToken?()
            }
        }) { (error) in
            
        }
    }
}
