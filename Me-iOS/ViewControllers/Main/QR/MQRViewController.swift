//
//  MQRViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

enum QRTypeScann: String {
    case authToken = "auth_token"
    case voucher = "voucher"
    case record = "record"
    case testTransaction = "demo_voucher"
}

class MQRViewController: HSScanViewController {
    
    private lazy var qrViewModel: QRViewModel = {
        return QRViewModel()
    }()
    private var voucher: Voucher!
    private var testToken: String!
    private var productVoucher: [Transaction]! = []
    
    private var recordValidateResponse: RecordValidation!
    
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
                    self?.qrViewModel.getOrganizations()
                    self?.recordValidateResponse = recordValidation
                    
                }else {
                    KVSpinnerView.dismiss()
                    self?.showErrorServer()
                    
                }
            }
        }
        
        qrViewModel.completeOrganization = { [unowned self] (organizations) in
            DispatchQueue.main.async {
                
                if organizations.count != 0 {
                    
                    if organizations.count == 1 {
                        self.qrViewModel.initApproveValidationRecord(code: self.recordValidateResponse.uuid ?? "", organization:  OrganizationRecord(organization_id: organizations.first?.organization_id ?? 0))
                    }else {
                        
                        let popOverVC = OrganizationValidatorViewController(nibName: "OrganizationValidatorViewController", bundle: nil)
                        popOverVC.recordEmployeesOrganizations = organizations
                        popOverVC.delegate = self
                        self.tabBarController?.addChild(popOverVC)
                        popOverVC.view.frame = CGRect(x: 0, y: 0, width: (self.tabBarController?.view.frame.size.width)!, height: (self.tabBarController?.view.frame.size.height)!)
                        self.tabBarController?.view.addSubview(popOverVC.view)
                    }
                    
                }else {
                    
                    self.qrViewModel.initApproveValidationRecord(code: self.recordValidateResponse.uuid ?? "", organization:  OrganizationRecord(organization_id:  0))
                    
                }
            }
        }
        
        qrViewModel.validateApproveRecord = { [weak self] (statusCode) in
            
            DispatchQueue.main.async {
                
                if statusCode != 503 {
                    KVSpinnerView.dismiss()
                    if statusCode != 401 {
                        
                        self?.showSimpleAlertWithSingleAction(title: Localize.success(), message: Localize.a_record_has_been_validated(),
                                                              okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
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
                self?.productVoucher.removeAll()
                if statusCode != 503 {
                    KVSpinnerView.dismiss()
                    if statusCode != 403 {
                        self?.voucher = voucher
                        
                        if voucher.fund?.type != FundType.subsidies.rawValue {
                            
                            if voucher.allowed_organizations?.count != 0 && voucher.allowed_organizations?.count  != nil {
                                
                                self?.qrViewModel.iniProductsFromVoucher(address: voucher.address ?? "")
                                
                            }else if voucher.product != nil{
                                
                                if voucher.product?.price != "0.00"{
                                    
                                    self?.performSegue(withIdentifier: R.segue.mqrViewController.goToVoucherPayment, sender: nil)
                                }else{
                                    
                                    self?.showSimpleAlertWithSingleAction(title: Localize.error_exclamation(),
                                                                          message: Localize.this_product_voucher_is_used(),
                                                                          okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                                                                            self?.scanWorker.start()
                                                                          }))
                                }
                                
                            }else {
                                
                                self?.showSimpleAlertWithSingleAction(title: Localize.error_exclamation(),
                                                                      message: Localize.sorry_you_do_not_meet_the_criteria_for_this_voucher(),
                                                                      okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                                                                        self?.scanWorker.start()
                                                                      }))
                            }
                        }else {
                            self?.openSubsidies()
                        }
                    }else {
                        
                        self?.showSimpleAlertWithSingleAction(title: Localize.error_exclamation(), message: Localize.you_cant_scan_this_voucher_you_are_not_accepted_as_provider_for_fund(), okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
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
        
        qrViewModel.getProducts = { [unowned self] (products) in
            
            DispatchQueue.main.async {
                if self.voucher.amount != "0.00" || products.count != 0 {
                    
                    products.forEach({ (voucherToken) in
                        if voucherToken.product?.organization_id == self.voucher.allowed_organizations?.first?.id {
                            self.productVoucher.append(voucherToken)
                        }
                    })
                    if self.productVoucher.count != 0 {
                        self.performSegue(withIdentifier: R.segue.mqrViewController.goToChooseProduct, sender: nil)
                    }else {
                        self.performSegue(withIdentifier: R.segue.mqrViewController.goToVoucherPayment, sender: nil)
                    }
                }else {
                    
                    self.showSimpleAlertWithSingleAction(title: Localize.error_exclamation(),
                                                         message: Localize.the_voucher_is_empty(),
                                                     okAction: UIAlertAction(title: Localize.ok(), style: .default, handler: { (action) in
                                                                                   self.scanWorker.start()
                                                                                 }))
            }
        }
    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13, *) {
        }else {
            self.setStatusBarStyle(.lightContent)
        }
        if scanWorker != nil {
            scanWorker.start()
            setupAccessibility()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let paymentVC = R.segue.mqrViewController.goToVoucherPayment(segue: segue) {
            paymentVC.destination.testToken = testToken
            paymentVC.destination.voucher = voucher
            paymentVC.destination.tabBar = self.tabBarController
            
        }else if let productReservation =  R.segue.mqrViewController.goToChooseProduct(segue: segue) {
            productReservation.destination.voucher = voucher
            productReservation.destination.voucherTokens = productVoucher.filter({$0.amount != "0.0"})
            productReservation.destination.vc = self
            productReservation.destination.tabBar = self.tabBarController
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
                                                           message: Localize.you_sure_you_want_to_login_device(),
                                                           okAction: UIAlertAction(title: Localize.yes(), style: .default, handler: { (action) in
                                                            KVSpinnerView.show()
                                                            self.qrViewModel.initAuthorizeToken(token: qr.value)
                                                            
                                                           }),
                                                           cancelAction: UIAlertAction(title: Localize.no(), style: .cancel, handler: { (action) in
                                                            
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
                            
                        } else if qr.type == QRTypeScann.testTransaction.rawValue {
                            self.scanWorker.stop()
                            self.testToken = qr.value
                            self.performSegue(withIdentifier: R.segue.mqrViewController.goToVoucherPayment, sender: nil)
                        }
                    }
                } catch {
                    KVSpinnerView.dismiss()
                    self.scanWorker.start()
                    if let qrValue = Int(scanResult.scanResultString!), String(qrValue).count == 12  {
                        let qrStringValue = String(qrValue)
                        self.scanWorker.stop()
                        KVSpinnerView.show()
                        self.qrViewModel.initVoucherAddress(address: qrStringValue)
                    }else {
                        showSimpleToast(message: "Unknown QR-code!")
                    }
                }
            }
        }else {
            
            self.scanWorker.start()
            showInternetUnable()
        }
        
        
    }
}

extension MQRViewController: OrganizationValidatorViewControllerDelegate {
    func selectOrganizationVoucher(organization: AllowedOrganization, vc: UIViewController) {
        
    }
    
    
    func close() {
        self.scanWorker.start()
    }
    
    func selectOrganization(organization: EmployeesOrganization, vc: UIViewController) {
        self.showSimpleAlertWithAction(title: self.recordValidateResponse.name ?? "", message: self.recordValidateResponse.value ?? "",
                                       okAction: UIAlertAction(title: Localize.validate(), style: .default, handler: { (action) in
                                        (vc as! OrganizationValidatorViewController).close(UIButton())
                                        self.qrViewModel.initApproveValidationRecord(code: self.recordValidateResponse.uuid ?? "", organization:  OrganizationRecord(organization_id: organization.organization_id ?? 0))
                                       }),
                                       cancelAction: UIAlertAction(title: Localize.cancel(), style: .cancel, handler: { (action) in
                                       }))
    }
}

extension MQRViewController {
    func openSubsidies() {
        let actionsVC = MActionsViewController()
        actionsVC.modalPresentationStyle = .fullScreen
        actionsVC.voucher = voucher
        self.present(actionsVC, animated: true)
    }
}

// MARK: - Accessibility Protocol

extension MQRViewController: AccessibilityProtocol {
    func setupAccessibility() {
        self.scanWorker.isAccessibilityElement = true
        self.scanWorker.accessibilityLabel = "Scan any me qr code"
        self.scanWorker.accessibilityTraits = .none
    }
}
