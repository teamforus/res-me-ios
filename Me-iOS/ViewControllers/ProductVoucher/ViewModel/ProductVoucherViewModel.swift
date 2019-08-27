//
//  ProductVoucherViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation
import KVSpinnerView

class ProductVoucherViewModel{
    
    var commonServices: CommonServiceProtocol!
    
    var complete: ((Voucher)->())?
    var completeSendEmail: ((Int)->())?
    var completeExchangeToken: ((String)->())?
    var vc: UIViewController!
    
    init(commonServices: CommonServiceProtocol = CommonService()) {
        self.commonServices = commonServices
    }
    
    func initFetchById(address: String){
        
        commonServices.getById(request: "platform/vouchers/", id: address, complete: { (response: ResponseData<Voucher>, statusCode) in

            if statusCode != 503 {
                
            self.complete!(response.data!)
                
            }else {
                
                KVSpinnerView.dismiss()
                self.vc.showErrorServer()
            }

        }, failure: { (error) in
            print(error)
        })
        
    }
    
    func sendEmail(address: String) {
        
        commonServices.postWithoutParamtersAndResponse(request: "platform/vouchers/"+address+"/send-email", complete: { (statusCode) in
            self.completeSendEmail?(statusCode)
        }) { (error) in
            
        }
        
    }
    
    func openVoucher() {
        
        commonServices.post(request: "identity/proxy/short-token") { (response: ExchangeToken, statusCode) in
            
            if statusCode != 503 {
                
                self.completeExchangeToken?(response.exchange_token ?? "")
                
            }else {
                
                KVSpinnerView.dismiss()
                self.vc.showErrorServer()
                
            }
        }
    }
    
}
