//
//  MVoucherViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import StoreKit

enum VoucherType: Int {
    case valute = 0
    case vouchers = 1
}

class MVouchersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    var isFromLogin: Bool!
    @IBOutlet weak var segmentController: HBSegmentedControl!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var transactionButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel_DarkMode!
    var voucherType: VoucherType! = .vouchers
    lazy var voucherViewModel: VouchersViewModel = {
        return VouchersViewModel()
    }()
    var dataSource: VouchersDataSource!
    var wallet: Office!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupAccessibility()
        if !Preference.tapToSeeTransactionTipHasShown {
            Preference.tapToSeeTransactionTipHasShown = true
            transactionButton?.toolTip(message: Localize.tap_here_you_want_to_see_list_transaction(), style: .dark, location: .bottom, offset: CGPoint(x: -50, y: 0))
        }
        
        setupSegmentControll()
        voucherViewModel.completeIdentity = { [unowned self] (response) in
            DispatchQueue.main.async {
                self.wallet = response
            }
        }
        
        voucherViewModel.getIndentity()
        setupTableView()
        initFetch()
        receiveFetch()
    }
    
    private func receiveFetch() {
        voucherViewModel.complete = { [weak self] (vouchers) in
            
            DispatchQueue.main.async {
                
                self?.voucherViewModel.sendPushToken(token: UserDefaults.standard.string(forKey: "TOKENPUSH") ?? "")
                self?.dataSource = VouchersDataSource(vouchers: vouchers, wallet: nil)
                self?.tableView.dataSource = self?.dataSource
                self?.tableView.reloadData()
                if vouchers.count == 0 {
                    
                    self?.tableView.isHidden = true
                }else {
                    
                    self?.tableView.isHidden = false
                }
                KVSpinnerView.dismiss()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func setupTableView() {
        registerForPreviewing(with: self, sourceView: tableView)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
    }
    
    private func setupSegmentControll() {
        segmentController.items = ["Valute", Localize.vouchers()]
        segmentController.selectedIndex = 1
        segmentController.font = UIFont(name: "GoogleSans-Medium", size: 14)
        segmentController.unselectedLabelColor = #colorLiteral(red: 0.631372549, green: 0.6509803922, blue: 0.6784313725, alpha: 1)
        segmentController.selectedLabelColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.968627451, alpha: 1)
        segmentController.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
        segmentController.borderColor = .clear
        segmentView.layer.cornerRadius = 8.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13, *) {
        }else {
            self.setStatusBarStyle(.default)
        }
    }
    
    func initFetch() {
        
        if isReachable() {
            
            KVSpinnerView.show()
            voucherViewModel.vc = self
            voucherViewModel.initFetch()
            
        }else {
            
            showInternetUnable()
        }
    }
    
    @objc func refreshData(_ sender: Any) {
        initFetch()
    }
    
    @objc func segmentSelected(sender:HBSegmentedControl) {
        
        switch sender.selectedIndex {
        case VoucherType.valute.rawValue:
            voucherType = .valute
            self.tableView.reloadData()
            self.tableView.isHidden = false
            break
        case VoucherType.vouchers.rawValue:
            voucherType = .vouchers
            if self.dataSource.vouchers.count == 0 {
                self.tableView.isHidden = true
            }else {
                self.tableView.isHidden = false
            }
            self.tableView.reloadData()
            break
        default: break
        }
    }
    
    @IBAction func openTransaction(_ sender: UIButton) {
        transactionButton.removeToolTip(with: Localize.tap_here_you_want_to_see_list_transaction())
        let transactionVC = MTransactionsViewController()
        transactionVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(transactionVC, animated: true)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         if segue.identifier == "goToVoucher" {
            if let voucherVC = segue.destination as? MVoucherViewController {
                voucherVC.address = self.dataSource.vouchers[tableView.indexPathForSelectedRow?.row ?? 0].address
            }
        }
    }
}

extension MVouchersViewController: UITableViewDelegate{
    
    @objc func send(_ sender: UIButton) {
        self.showPopUPWithAnimation(vc: SendEtherViewController(nibName: "SendEtherViewController", bundle: nil))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let voucher = self.dataSource.vouchers[indexPath.row]
        
        switch voucherType {
        case .vouchers?:
            if voucher.product != nil {
                let vc = ProductVoucherViewController()
                vc.address = voucher.address ?? ""
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: nil)
            }else {
                self.performSegue(withIdentifier: "goToVoucher", sender: nil)
            }
        default:
            break
        }
    }
}

extension MVouchersViewController: UIViewControllerPreviewingDelegate{
    
    private func createDetailViewControllerIndexPath(vc: UIViewController, indexPath: IndexPath) -> UIViewController {
        
        let detailViewController = vc
        
        return detailViewController
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        switch voucherType {
        case .vouchers?:
            guard let indexPath = tableView.indexPathForRow(at: location) else {
                return nil
            }
            let voucher = self.dataSource.vouchers[indexPath.row]
            var detailViewController = UIViewController()
            if voucherViewModel.selectedVoucher?.product != nil {
                let productVC = ProductVoucherViewController()
                productVC.address = voucherViewModel.selectedVoucher?.address ?? ""
                detailViewController = productVC
            }else {
                let storyboard = R.storyboard.voucher()
                if let voucherVC = storyboard.instantiateViewController(withIdentifier: "voucher") as? MVoucherViewController {
                    voucherVC.address = voucher.address ?? ""
                    detailViewController = voucherVC
                }
            }
            
            return detailViewController
        default:
            return nil
        }
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
// MARK: - Accessibility Protocol

extension MVouchersViewController: AccessibilityProtocol {
    
    func setupAccessibility() {
        if let valute = segmentController.accessibilityElement(at: 0) as? UIView {
            valute.setupAccesibility(description: "Choose to show all valute", accessibilityTraits: .causesPageTurn)
        }
        
        if let vouchers = segmentController.accessibilityElement(at: 1) as? UIView {
            vouchers.setupAccesibility(description: "Choose to show all vouchers", accessibilityTraits: .causesPageTurn)
        }
        titleLabel.setupAccesibility(description: Localize.vouchers(), accessibilityTraits: .header)
    }
}
