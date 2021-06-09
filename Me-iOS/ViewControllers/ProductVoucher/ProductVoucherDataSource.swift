//
//  ProductVoucherDataSource.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 30.05.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SafariServices

class ProductVoucherDataSource: NSObject {
    var voucher: Voucher
    var parentViewController: ProductVoucherViewController
    
    init(voucher: Voucher, parentViewController: ProductVoucherViewController) {
        self.voucher = voucher
        self.parentViewController = parentViewController
        super.init()
    }
    
    func didOpenQR() {
       let popOverVC = PullUpQRViewController(nib: R.nib.pullUpQRViewController)
       popOverVC.voucher = voucher
       popOverVC.qrType = .Voucher
        parentViewController.showPopUPWithAnimation(vc: popOverVC)
   }
   
    func showVoucherInfo() {
       if voucher.fund?.url_webshop != nil {
           if let url = URL(string: "\(voucher.fund?.url_webshop ?? "")product/\(voucher.product?.id ?? 0)") {
               let safariVC = SFSafariViewController(url: url)
            self.parentViewController.present(safariVC, animated: true, completion: nil)
           }
       }else {
           if let url = URL(string: "https://kerstpakket.forus.io") {
               let safariVC = SFSafariViewController(url: url)
            self.parentViewController.present(safariVC, animated: true, completion: nil)
           }
       }
   }
   
    func sendVoucherToMail() {
        parentViewController.productViewModel.completeSendEmail = { [weak self] (statusCode) in
           DispatchQueue.main.async {
            self?.parentViewController.showPopUPWithAnimation(vc: SuccessSendingViewController(nib: R.nib.successSendingViewController))
           }
       }
        parentViewController.showSimpleAlertWithAction(title: Localize.email_to_me(),
                                 message: Localize.send_an_email_to_the_provider(),
                                 okAction: UIAlertAction(title: Localize.confirm(), style: .default, handler: { (action) in
                                    self.parentViewController.productViewModel.sendEmail(address: self.voucher.address ?? "")
                                 }),
                                 cancelAction: UIAlertAction(title: Localize.cancel(), style: .cancel, handler: nil))
   }
   
    func callPhone() {
       if let phone = voucher.offices?.first?.phone {
           guard let number = URL(string: "tel://" + (phone)) else { return }
           UIApplication.shared.open(number)
       }
   }
   
    func copyEmailToClipBoard() {
       UIPasteboard.general.string = self.voucher.offices?.first?.organization?.email
        self.parentViewController.showSimpleToast(message: Localize.copied_to_clipboard())
   }
}

// MARK: - UITableViewDataSource
extension ProductVoucherDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainTableViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = MainTableViewSection.allCases[indexPath.row]
        switch sections {
        case .voucher:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MProductVoucherTableViewCell.identifier, for: indexPath) as? MProductVoucherTableViewCell else {
                return UITableViewCell()
            }
            cell.setupVoucher(voucher: voucher)
            return cell
        case .infoVoucher:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MInfoVoucherTableViewCell.identifier, for: indexPath) as? MInfoVoucherTableViewCell else {
                return UITableViewCell()
            }
            cell.emailCompletion = { [weak self] () in
                self?.sendVoucherToMail()
            }
            
            cell.infoCompletion = { [weak self] () in
                self?.showVoucherInfo()
            }
            return cell
        case .mapDetail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MMapDetailsTableViewCell.identifier, for: indexPath) as? MMapDetailsTableViewCell else {
                return UITableViewCell()
            }
            cell.parentViewController = parentViewController
            cell.setupVoucher(voucher: voucher)
            return cell
            
        case .adress:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MAdressTableViewCell.identifier, for: indexPath) as? MAdressTableViewCell else {
                return UITableViewCell()
            }
            cell.setupVoucher(voucher: voucher)
            return cell
            
        case .telephone:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MTelephoneTableViewCell.identifier, for: indexPath) as? MTelephoneTableViewCell else {
                return UITableViewCell()
            }
            cell.setupVoucher(voucher: voucher)
            return cell
            
        case .email:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MAdressTableViewCell.identifier, for: indexPath) as? MAdressTableViewCell else {
                return UITableViewCell()
            }
            
            cell.sendEmailCompletion = { [weak self] () in
                self?.parentViewController.sendEmailToProvider()
            }
            
            cell.copyCompletion = { [weak self] () in
                self?.copyEmailToClipBoard()
            }
            
            cell.setupEmail(voucher: voucher)
            return cell
            
        case .branches:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MBranchesTableViewCell.identifier, for: indexPath) as? MBranchesTableViewCell else {
                return UITableViewCell()
            }
            cell.setup(voucher: voucher)
            cell.parentViewController = parentViewController
            return cell
            
        }
    }
}
