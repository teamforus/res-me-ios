//
//  MProductReservationViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 8/22/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MProductReservationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    lazy var qrViewModel: QRViewModel = {
        return QRViewModel()
    }()
    @IBOutlet weak var completeAnAmountButton: ShadowButton!
    
    var voucherTokens: [Transaction]! = []
    var voucher: Voucher!
    var vc: MQRViewController!
    var selectedProduct: Voucher!
    var tabBar: UITabBarController!
    @IBOutlet weak var goToVoucherButton: ShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAccessibility()
        qrViewModel.vcAlert = self
        goToVoucherButton.isHidden = voucher.amount == "0.00"
        
        qrViewModel.getVoucher = { [weak self] (voucher, statusCode) in
            DispatchQueue.main.async {
                self?.selectedProduct = voucher
                self?.performSegue(withIdentifier: "goToPaymentFromSelected", sender: nil)
            }
            
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPaymentFromSelected" {
            if let paymentVC = segue.destination as? MPaymentViewController {
                
                paymentVC.voucher = selectedProduct
                paymentVC.isFromReservation = true
                paymentVC.tabBar = self.tabBar
                
            }
        }else if segue.identifier == "goToPaymentSimple" {
            if let paymentVC = segue.destination as? MPaymentViewController {
                
                paymentVC.isFromReservation = true
                paymentVC.voucher = voucher
                paymentVC.tabBar = self.tabBar
                
            }
        }
    }
    
    
}

extension MProductReservationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voucherTokens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductReservationTableViewCell
        let voucherToken = voucherTokens[indexPath.row]
        
        cell.productReservation = voucherToken
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.qrViewModel.initVoucherAddress(address: voucherTokens[indexPath.row].address ?? "")
        
    }
}

// MARK: - Accessibility Protocol

extension MProductReservationViewController: AccessibilityProtocol {
    func setupAccessibility() {
        completeAnAmountButton.setupAccesibility(description: Localize.complete_amount(), accessibilityTraits: .button)
    }
}
