//
//  MQRViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import KVSpinnerView

enum QRTypeScann: String {
    case authToken = "auth_token"
    case voucher = "voucher"
    case record = "record"
}

class MQRViewController: HSScanViewController {
    
    lazy var qrViewModel: QRViewModel = {
        return QRViewModel()
    }()
    var voucher: Voucher!
    var productVoucher: [Transaction]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.scanCodeTypes  = [.qr]
        
        qrViewModel.vc = self
        qrViewModel.vcAlert = self
        
        qrViewModel.authorizeToken = { [weak self] (statusCode) in
            DispatchQueue.main.async {
                KVSpinnerView.dismiss()
                if statusCode != 503 {
                    
                    
                    self?.scanWorker.start()
                    
                }else {
                    
                    self?.showErrorServer()
                }
                
            }
        }
        
        qrViewModel.validateRecord = { [weak self] (recordValidation, statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode != 503 {
                    KVSpinnerView.dismiss()
                    self?.showSimpleAlertWithAction(title: recordValidation.name ?? "", message: recordValidation.value ?? "",
                                                    okAction: UIAlertAction(title: "Validate".localized(), style: .default, handler: { (action) in
                                                        
                                                        self?.qrViewModel.initApproveValidationRecord(code: recordValidation.uuid ?? "")
                                                        
                                                    }),
                                                    cancelAction: UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: { (action) in
                                                        self?.scanWorker.start()
                                                    }))
                }else {
                    KVSpinnerView.dismiss()
                    self?.showErrorServer()
                    
                }
                
            }
            
        }
        
        qrViewModel.validateApproveRecord = { [weak self] (statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode != 503 {
                    KVSpinnerView.dismiss()
                    if statusCode != 401 {
                        
                        self?.showSimpleAlertWithSingleAction(title: "Success".localized(), message: "A record has been validated!".localized(),
                                                              okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                                self?.scanWorker.start()
                                                              }))
                    }else {
                        KVSpinnerView.dismiss()
                        self?.showErrorServer()
                        
                    }
                    
                }
            }
        }
        
        qrViewModel.getVoucher = { [weak self] (voucher, statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode != 503 {
                    KVSpinnerView.dismiss()
                    if statusCode != 403 {
                        
                        if voucher.amount != "0.00" {
                            
                            self?.voucher = voucher
                            
                            if voucher.allowed_organizations?.count != 0 && voucher.allowed_organizations?.count  != nil {
                                
                                if voucher.product_vouchers?.count != 0 {
                                    voucher.product_vouchers?.forEach({ (voucherToken) in
                                        if voucherToken.product?.organization_id == voucher.allowed_organizations?.first?.id {
                                            self?.productVoucher.append(voucherToken)
                                        }
                                    })
                                    
                                    self?.performSegue(withIdentifier: "goToChooseProduct", sender: nil)
                                }else {
                                    
                                    self?.performSegue(withIdentifier: "goToVoucherPayment", sender: nil)
                                }
                                
                            }else if voucher.product != nil{
                                
                                if voucher.product?.price != "0.00"{
                                    
                                    self?.performSegue(withIdentifier: "goToVoucherPayment", sender: nil)
                                }else{
                                    
                                    self?.showSimpleAlertWithSingleAction(title: "Error!".localized(),
                                                                          message: "This product voucher is used!".localized(),
                                                                          okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                                            self?.scanWorker.start()
                                                                          }))
                                }
                                
                            }else {
                                
                                self?.showSimpleAlertWithSingleAction(title: "Error!".localized(),
                                                                      message: "Sorry you do not meet the criteria for this voucher".localized(),
                                                                      okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                                        self?.scanWorker.start()
                                                                      }))
                            }
                        }else {
                            
                            self?.showSimpleAlertWithSingleAction(title: "Error!".localized(),
                                                                  message: "The voucher is empty! No transactions can be done.".localized(),
                                                                  okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                                                    self?.scanWorker.start()
                                                                  }))
                        }
                    }else {
                        
                        self?.showSimpleAlertWithSingleAction(title: "Error!".localized(), message: "You can't scan this voucher. You are not accepted as a provider for the fund that hands out these vouchers.".localized(), okAction: UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self?.scanWorker.start()
                        }))
                    }
                    
                    //                    self?.scanWorker.start()
                    
                }else {
                    KVSpinnerView.dismiss()
                    self?.showErrorServer()
                }
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBarStyle(.lightContent)
        if scanWorker != nil {
            scanWorker.start()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToVoucherPayment" {
            if let paymentVC = segue.destination as? MPaymentViewController {
                
                paymentVC.voucher = voucher
                paymentVC.tabBar = self.tabBarController
                
            }
        }else if segue.identifier == "goToChooseProduct" {
            if let productReservation = segue.destination as? MProductReservationViewController {
                
                productReservation.voucher = voucher
                productReservation.voucherTokens = productVoucher
                productReservation.vc = self
                productReservation.tabBar = self.tabBarController
                
            }
        }
        
    }
    
}

extension MQRViewController: HSScanViewControllerDelegate{
    
    func scanFinished(scanResult: ScanResult, error: String?) {
        if isReachable() {
            
            
            if let data = scanResult.scanResultString?.data(using: .utf8) {
                let jsonDecoder = JSONDecoder()
                do {
                    
                    let qr = try jsonDecoder.decode(QRText.self, from: data)
                    
                    if qr.type != nil
                    {
                        if qr.type == QRTypeScann.authToken.rawValue {
                            self.scanWorker.stop()
                            self.showSimpleAlertWithAction(title: "Login QR",
                                                           message: "You sure you wan't to login this device?".localized(),
                                                           okAction: UIAlertAction(title: "YES".localized(), style: .default, handler: { (action) in
                                                            KVSpinnerView.show()
                                                            self.qrViewModel.initAuthorizeToken(token: qr.value)
                                                            
                                                           }),
                                                           cancelAction: UIAlertAction(title: "NO".localized(), style: .cancel, handler: { (action) in
                                                            
                                                            self.scanWorker.start()
                                                           }))
                            
                            
                        } else if qr.type == QRTypeScann.voucher.rawValue {
                            
                            self.scanWorker.stop()
                            KVSpinnerView.show()
                            self.qrViewModel.initVoucherAddress(address: qr.value)
                            
                            
                        } else if qr.type == QRTypeScann.record.rawValue {
                            
                            self.scanWorker.stop()
                            KVSpinnerView.show()
                            self.qrViewModel.initValidationRecord(code: qr.value)
                            
                        }
                    }
                } catch {
                    KVSpinnerView.dismiss()
                    showSimpleToast(message: "Unknown QR-code!")
                }
            }
        }else {
            
            self.scanWorker.start()
            showInternetUnable()
        }
        
        
    }
}
