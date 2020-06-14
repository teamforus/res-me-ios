//
//  MVoucherViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 5/8/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit
import ISHPullUp
import KVSpinnerView

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
    
    var voucherType: VoucherType!
    lazy var voucherViewModel: VouchersViewModel = {
        return VouchersViewModel()
    }()
    
    var wallet: Office!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefrehshControl()
        voucherType = .vouchers
        setupSegmentController()
        voucherViewModel.getIndentity()
        completionsBlocks()
        initFetch()
    }
    
    func setupRefrehshControl() {
        registerForPreviewing(with: self, sourceView: tableView)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    func setupSegmentController() {
        segmentController.items = ["Valute", Localize.vouchers()]
        segmentController.selectedIndex = 1
        segmentController.font = UIFont(name: "GoogleSans-Medium", size: 14)
        segmentController.unselectedLabelColor = #colorLiteral(red: 0.631372549, green: 0.6509803922, blue: 0.6784313725, alpha: 1)
        segmentController.selectedLabelColor = #colorLiteral(red: 0.2078431373, green: 0.3921568627, blue: 0.968627451, alpha: 1)
        segmentController.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
        segmentController.borderColor = .clear
        segmentView.layer.cornerRadius = 8.0
    }
    
    func completionsBlocks() {
        voucherViewModel.complete = { [weak self] (vouchers) in
            
            DispatchQueue.main.async {
                
                self?.voucherViewModel.sendPushToken(token: UserDefaults.standard.string(forKey: "TOKENPUSH") ?? "")
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
        
        
        
        voucherViewModel.completeIdentity = { [unowned self] (response) in
            DispatchQueue.main.async {
                self.wallet = response
            }
        }
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
            if voucherViewModel.numberOfCells == 0 {
                self.tableView.isHidden = true
            }else {
                self.tableView.isHidden = false
            }
            self.tableView.reloadData()
            break
        default: break
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToProduct" {
            
            let generalVC = didSetPullUP(storyboard: R.storyboard.productVoucher(), segue: segue)
            (generalVC.contentViewController as! MProductVoucherViewController).address = self.voucherViewModel.selectedVoucher?.address ?? ""
            (generalVC.bottomViewController as! CommonBottomViewController).voucher = self.voucherViewModel.selectedVoucher
            (generalVC.bottomViewController as! CommonBottomViewController).qrType = .Voucher
            
        }else if segue.identifier == "goToVoucher" {
            
            let generalVC = didSetPullUP(storyboard: R.storyboard.voucher(), segue: segue)
            (generalVC.contentViewController as! MVoucherViewController).address = self.voucherViewModel.selectedVoucher?.address ?? ""
            (generalVC.bottomViewController as! CommonBottomViewController).voucher = self.voucherViewModel.selectedVoucher
            (generalVC.bottomViewController as! CommonBottomViewController).qrType = .Voucher
            
        }
    }
    
    func didSetPullUPWithoutSegue(storyboard: UIStoryboard, isProduct: Bool) -> CommonPullUpViewController {
        
        let passVC = storyboard.instantiateViewController(withIdentifier: "general") as! CommonPullUpViewController
        
        passVC.contentViewController = storyboard.instantiateViewController(withIdentifier: "content")
        
        passVC.bottomViewController = storyboard.instantiateViewController(withIdentifier: "bottom")
        
        (passVC.bottomViewController as! CommonBottomViewController).pullUpController = passVC
        passVC.sizingDelegate = (passVC.bottomViewController as! CommonBottomViewController)
        
        if isProduct {
            
            (passVC.contentViewController as! MProductVoucherViewController).address = self.voucherViewModel.selectedVoucher?.address ?? ""
        }else {
            
            (passVC.contentViewController as! MVoucherViewController).address = self.voucherViewModel.selectedVoucher?.address ?? ""
            
        }
        passVC.stateDelegate = (passVC.bottomViewController as! CommonBottomViewController)
        (passVC.bottomViewController as! CommonBottomViewController).voucher = self.voucherViewModel.selectedVoucher
        (passVC.bottomViewController as! CommonBottomViewController).qrType = .Voucher
        
        return passVC
    }
    
}

extension MVouchersViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch voucherType {
        case .valute?:
            return 1
        case .vouchers?:
            return voucherViewModel.numberOfCells
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch voucherType {
        case .valute?:
            let cell = tableView.dequeueReusableCell(withIdentifier: "valuteCell", for: indexPath) as! ValuteTableViewCell
            cell.wallet = self.wallet.wallet
            cell.sendButton.addTarget(self, action: #selector(send(_:)), for: .touchUpInside)
            return cell
        case .vouchers?:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VoucherTableViewCell
            
            cell.voucher = voucherViewModel.getCellViewModel(at: indexPath)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @objc func send(_ sender: UIButton) {
        self.showPopUPWithAnimation(vc: SendEtherViewController(nibName: "SendEtherViewController", bundle: nil))
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        switch voucherType {
        case .vouchers?:
            
            self.voucherViewModel.userPressed(at: indexPath)
            
            if voucherViewModel.isAllowSegue {
                if voucherViewModel.selectedVoucher?.product != nil {
                    self.performSegue(withIdentifier: "goToProduct", sender: nil)
                }else {
                    self.performSegue(withIdentifier: "goToVoucher", sender: nil)
                }
                return indexPath
            }else {
                return nil
            }
            
        default:
            return nil
            
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
            
            self.voucherViewModel.userPressed(at: indexPath)
            var detailViewController = UIViewController()
            if voucherViewModel.selectedVoucher?.product != nil {
                detailViewController = createDetailViewControllerIndexPath(vc: didSetPullUPWithoutSegue(storyboard: R.storyboard.productVoucher(), isProduct: true),
                                                                           indexPath: indexPath)
            }else {
                detailViewController = createDetailViewControllerIndexPath(vc: didSetPullUPWithoutSegue(storyboard: R.storyboard.voucher(), isProduct: false),
                                                                           indexPath: indexPath)
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

extension UIViewController{
    
    func didSetPullUP(storyboard: UIStoryboard, segue: UIStoryboardSegue) -> CommonPullUpViewController {
        
        let passVC = segue.destination as! CommonPullUpViewController
        
        passVC.contentViewController = storyboard.instantiateViewController(withIdentifier: "content")
        
        passVC.bottomViewController = storyboard.instantiateViewController(withIdentifier: "bottom")
        
        (passVC.bottomViewController as! CommonBottomViewController).pullUpController = passVC
        passVC.sizingDelegate = (passVC.bottomViewController as! CommonBottomViewController)
        passVC.stateDelegate = (passVC.bottomViewController as! CommonBottomViewController)
        
        return passVC
    }
    
}
