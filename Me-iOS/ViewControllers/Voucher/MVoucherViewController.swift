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
    @IBOutlet weak var dateCreated: UILabel_DarkMode!
    @IBOutlet weak var voucherName: UILabel_DarkMode!
    @IBOutlet weak var organizationName: UILabel_DarkMode!
    @IBOutlet weak var priceLabel: UILabel_DarkMode!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendEmailButton: ShadowButton!
    @IBOutlet weak var voucherInfoButton: ShadowButton!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var qrCodeButton: UIButton!
    @IBOutlet weak var historyLabel: UILabel_DarkMode!
    @IBOutlet weak var activatedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel_DarkMode!
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var emptyLabel: UILabel!
    
    lazy var voucherViewModel: VoucherViewModel = {
        return VoucherViewModel()
    }()
    var address: String!
    var voucher: Voucher!
    @IBOutlet var images: [SkeletonUIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAccessibility()
        self.heightConstraint.constant = 260
        self.qrCodeButton.isEnabled = false
        
        images.forEach { (view) in
            view.startAnimating()
        }
        voucherViewModel.reloadDataVoucher = { [weak self] (voucher) in
            
            DispatchQueue.main.async {
                self?.priceLabel.isHidden = voucher.fund?.type == FundType.subsidies.rawValue
                self?.voucherName.text = voucher.fund?.name ?? ""
                self?.organizationName.text = voucher.fund?.organization?.name ?? ""
                if let price = voucher.amount {
                    //                    if voucher.fund?.currency == "eur" {
                    self?.priceLabel.text = "€ \(price.substringLeftPart()),\(price.substringRightPart())"
                    //                    }else {
                    //                        self?.priceLabel.attributedText = "ETH \(price.substringLeftPart()).{\(price.substringRightPart())}".customText(fontBigSize: 20, minFontSize: 14)
                    //                    }
                }else {
                    
                    self?.priceLabel.text = "€ 0,0"
                }
                
                if voucher.expire_at?.date?.formatDate() ?? Date() >= Date() {
                    self?.qrCodeImage.isHidden = false
                    self?.sendEmailButton.isHidden = false
                    self?.voucherInfoButton.isHidden = false
                    self?.buttonsView.isHidden = false
                    self?.heightConstraint.constant = 322
                    self?.qrCodeButton.isEnabled = true
                }
                self?.historyLabel.isHidden = false
                self?.activatedLabel.isHidden = false
                self?.qrCodeImage.generateQRCode(from: "{\"type\": \"voucher\",\"value\": \"\(voucher.address ?? "")\" }")
                self?.dateCreated.text = voucher.created_at?.dateFormaterNormalDate()
                self?.voucher = voucher
                
                self?.images.forEach { (view) in
                    view.stopAnimating()
                }
            }
            
            
        }
        
        voucherViewModel.reloadTableViewClosure = { [weak self] in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.heightTableViewConstraint.constant = CGFloat(self.voucherViewModel.numberOfCells * 89)
                self.emptyLabel.isHidden = self.voucherViewModel.numberOfCells != 0
                self.tableView.reloadData()
            }
        }
        
        
        if isReachable() {
            
            voucherViewModel.vc = self
            voucherViewModel.initFetchById(address: address)
            
        }else {
            
            showInternetUnable()
            
        }
    }
    
    @IBAction func opendQR(_ sender: UIButton) {
        let popOverVC = PullUpQRViewController(nib: R.nib.pullUpQRViewController)
        popOverVC.voucher = voucher
        popOverVC.qrType = .Voucher
        showPopUPWithAnimation(vc: popOverVC)
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        
        voucherViewModel.completeSendEmail = { [weak self] (statusCode) in
            
            DispatchQueue.main.async {
                
                self?.showPopUPWithAnimation(vc: SuccessSendingViewController(nib: R.nib.successSendingViewController))
                
            }
        }
        
        showSimpleAlertWithAction(title: Localize.email_to_me(),
                                  message: Localize.send_voucher_to_your_email(),
                                  okAction: UIAlertAction(title: Localize.confirm(), style: .default, handler: { (action) in
                                    
                                    self.voucherViewModel.sendEmail(address: self.voucher.address ?? "")
                                    
                                  }),
                                  cancelAction: UIAlertAction(title: Localize.cancel(), style: .cancel, handler: nil))
        
    }
    
    @IBAction func info(_ sender: Any) {
        voucherViewModel.openVoucher()
        
        voucherViewModel.completeExchangeToken = { [weak self] (token) in
            
            DispatchQueue.main.async {
                if let urlWebShop = self?.voucher.fund!.url_webshop, let address = self?.voucher.address {
                    if let url = URL(string: urlWebShop + "auth-link?token=" + token + "&target=voucher-" + address) {
                        let safariVC = SFSafariViewController(url: url)
                        self?.present(safariVC, animated: true, completion: nil)
                    }
                }else {
                    if let url = URL(string: "https://kerstpakket.forus.io") {
                        let safariVC = SFSafariViewController(url: url)
                        self?.present(safariVC, animated: true, completion: nil)
                    }
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
        
        let transaction = voucherViewModel.getCellViewModel(at: indexPath)
        if let voucher = self.voucher {
            cell.configure(transaction: transaction, isSubsidies: voucher.fund?.type == FundType.subsidies.rawValue)
        }
        return cell
    }
    
}

// MARK: - Accessibility Protocol

extension MVoucherViewController: AccessibilityProtocol {
    func setupAccessibility() {
        sendEmailButton.setupAccesibility(description: "Send voucher on email", accessibilityTraits: .button)
        voucherInfoButton.setupAccesibility(description: "Go to voucher info", accessibilityTraits: .button)
        qrCodeButton.setupAccesibility(description: "Tap to open qr code modal", accessibilityTraits: .button)
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


