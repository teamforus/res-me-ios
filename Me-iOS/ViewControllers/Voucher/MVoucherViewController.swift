//
//  MVoucherViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SafariServices

class MVoucherViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var voucherName: UILabel!
    @IBOutlet weak var organizationName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    lazy var voucherViewModel: VoucherViewModel = {
        return VoucherViewModel()
    }()
    var address: String!
    var voucher: Voucher!
    @IBOutlet var labeles: [SkeletonView]!
    @IBOutlet var images: [SkeletonUIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labeles.forEach { (view) in
            view.startAnimating()
        }
        
        images.forEach { (view) in
            view.startAnimating()
        }
        voucherViewModel.reloadDataVoucher = { [weak self] (voucher) in
            
            DispatchQueue.main.async {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                    NotificationCenter.default.post(name: NotificationName.TogleStateWindow, object: nil)
                })
                self?.voucherName.text = voucher.fund?.name ?? ""
                self?.organizationName.text = voucher.fund?.organization?.name ?? ""
                if let price = voucher.amount {
                    
                    self?.priceLabel.attributedText = "€ \(price.substringLeftPart()).{\(price.substringRightPart())}".customText(fontBigSize: 20, minFontSize: 14)
                }else {
                    
                    self?.priceLabel.attributedText = "0.{0}".customText(fontBigSize: 20, minFontSize: 14)
                }
                
                self?.qrImage.generateQRCode(from: "{\"type\": \"voucher\",\"value\": \"\(voucher.address ?? "")\" }")
                self?.dateCreated.text = voucher.created_at?.dateFormaterNormalDate()
                self?.voucher = voucher
                
                self?.labeles.forEach { (view) in
                    view.stopAnimating()
                }
                self?.images.forEach { (view) in
                    view.stopAnimating()
                }
            }
            
            
        }
        
        voucherViewModel.reloadTableViewClosure = { [weak self] in
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        
        if isReachable() {
            
            voucherViewModel.vc = self
            voucherViewModel.initFetchById(address: address)
            
        }else {
            
            showInternetUnable()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.set(visible: false, animated: true)
    }
    
    @IBAction func opendQR(_ sender: UIButton) {
        NotificationCenter.default.post(name: NotificationName.TogleStateWindow, object: nil)
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        
        voucherViewModel.completeSendEmail = { [weak self] (statusCode) in
            
            DispatchQueue.main.async {
                
                self?.showPopUPWithAnimation(vc: SuccessSendingViewController(nibName: "SuccessSendingViewController", bundle: nil))
                
            }
        }
        
        showSimpleAlertWithAction(title: "E-mail to me".localized(),
                                  message: "Send the voucher to your email?".localized(),
                                  okAction: UIAlertAction(title: "Confirm".localized(), style: .default, handler: { (action) in
                                    
                                    self.voucherViewModel.sendEmail(address: self.voucher.address ?? "")
                                    
                                  }),
                                  cancelAction: UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        
    }
    
    @IBAction func info(_ sender: Any) {
        voucherViewModel.openVoucher()
        
        voucherViewModel.completeExchangeToken = { [weak self] (token) in
            
            DispatchQueue.main.async {
                
                if let url = URL(string: (self?.voucher.fund!.url_webshop)! + "auth-link?token=" + token) {
                    let safariVC = SFSafariViewController(url: url)
                    self?.present(safariVC, animated: true, completion: nil)
                }
            }
        }
    }
}

extension MVoucherViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voucherViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionTableViewCell
        
        cell.transaction = voucherViewModel.getCellViewModel(at: indexPath)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didAnimateTransactioList()
    }
    
}

extension MVoucherViewController{
    
    func didAnimateTransactioList(){
        if voucherViewModel.numberOfCells > 8{
            if isFirstCellVisible(){
                self.heightConstraint.constant = 322
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }else{
                self.heightConstraint.constant = 60
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func isFirstCellVisible() -> Bool{
        let indexes = tableView.indexPathsForVisibleRows
        for indexPath in indexes!{
            if indexPath.row == 0{
                return true
            }
        }
        return false
    }
}
