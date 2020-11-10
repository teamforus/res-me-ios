//
//  VouchersViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import Foundation
import UIKit

class VouchersViewModel{
    
    var commonService: CommonServiceProtocol!
    var selectedVoucher: Voucher?
    var isAllowSegue: Bool = false
    var vc: UIViewController!
    
    var completeIdentity: ((Office)->())!
    var completeDeleteToken: ((Int)->())!
    
    
    private var cellViewModels: [Voucher] = [Voucher]() {
        didSet {
            complete?(cellViewModels)
        }
    }
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    var complete: (([Voucher])->())?
    
    func initFetch(){
        
        commonService.get(request: "platform/vouchers", complete: { (response: ResponseDataArray<Voucher>, statusCode) in
            if statusCode == 503 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showErrorServer()
                }
                
            }else if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            } else {
                
                self.processFetchedLunche(vouchers: response.data ?? [])
            }
            
        }, failure: { (error) in
            DispatchQueue.main.async {
                KVSpinnerView.dismiss()
            }
        })
        
    }
    
    func sendPushToken(token: String){
        commonService.postWithoutResponse(request: "platform/devices/register-push", body: BodyId(id: token), complete: { (statusCode) in
            print("Push Notification status code: \(statusCode)")
        }) { (error) in
        }
    }
    
    func deletePushToken(token: String){
        commonService.deleteWithoutResponse(request: "platform/devices/delete-push", body: BodyId(id: token), complete: { (statusCode) in
            print("Push Notification delete status code: \(statusCode)")
            self.completeDeleteToken?(statusCode)
        }) { (error) in
        }
        
    }
    
    func getIndentity(){
        commonService.get(request: "identity", complete: { (response: Office, statusCode) in
            if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                self.completeIdentity?(response)
            }
        }) { (error) in
            
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> Voucher {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( voucher: Voucher ) -> Voucher {
        
        return voucher
    }
    
    private func processFetchedLunche( vouchers: [Voucher] ) {
        var vms = [Voucher]()
        for voucher in vouchers {
            if voucher.product != nil {
                if voucher.transactions?.count == 0 {
                    vms.append( createCellViewModel(voucher: voucher) )
                }
            } else {
                vms.append( createCellViewModel(voucher: voucher) )
            }
        }
        self.cellViewModels = vms
    }
}

extension VouchersViewModel {
    
    func userPressed( at indexPath: IndexPath) {
        let voucher = self.cellViewModels[indexPath.row]
        self.isAllowSegue = true
        self.selectedVoucher = voucher
    }
}
