//
//  VoucherViewModel.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class VoucherViewModel{
    
    var commonService: CommonServiceProtocol!
    private var cellViewModels: [Transaction] = [Transaction]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    init(commonService: CommonServiceProtocol = CommonService()) {
        self.commonService = commonService
    }
    
    var reloadTableViewClosure: (()->())?
    var completeExchangeToken: ((String)->())?
    var reloadDataVoucher: ((Voucher)->())?
    var completeSendEmail: ((Int)->())?
    var vc: UIViewController!
    
    func initFetchById(address: String){
        
        commonService.getById(request: "platform/vouchers/", id: address, complete: { (response: ResponseData<Voucher>, statusCode) in
            
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
            }else {
                var array = response.data?.transactions ?? []
                array.append(contentsOf: response.data?.product_vouchers ?? [])
                
                self.processFetchedLunche(transactions: array.sorted(by: { $0.created_at?.compare($1.created_at ?? "") == .orderedDescending}))
                self.reloadDataVoucher?(response.data!)
                
            }
            
        }, failure: { (error) in
            print(error)
        })
        
    }
    
    func sendEmail(address: String) {
        
        
        commonService.postWithoutParamtersAndResponse(request: "platform/vouchers/"+address+"/send-email", complete: { (statusCode) in
            if statusCode == 401 {
                DispatchQueue.main.async {
                    KVSpinnerView.dismiss()
                    self.vc.showSimpleAlertWithSingleAction(title: Localize.expired_session(), message: Localize.your_session_has_expired() , okAction: UIAlertAction(title: Localize.log_out(), style: .default, handler: { (action) in
                        self.vc.logoutOptions()
                    }))
                }
            }else {
                self.completeSendEmail?(statusCode)
            }
        }) { (error) in
            
        }
        
    }
    
    func openVoucher() {
        
        commonService.post(request: "identity/proxy/short-token") { (response: ExchangeToken, statusCode) in
            
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
            }else {
                self.completeExchangeToken?(response.exchange_token ?? "")
            }
            
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> Transaction {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( transaction: Transaction ) -> Transaction {
        
        return transaction
    }
    
    private func processFetchedLunche( transactions: [Transaction] ) {
        var vms = [Transaction]()
        for transaction in transactions {
            vms.append( createCellViewModel(transaction: transaction) )
        }
        self.cellViewModels = vms
    }
    
}
