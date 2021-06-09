//
//  VouchersDataSource.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 24.05.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class VouchersDataSource: NSObject {
    var vouchers: [Voucher]
    var wallet: Office?
    var voucherType: VoucherType
    
    init(vouchers: [Voucher], wallet: Office?, voucherType: VoucherType = .vouchers) {
        self.vouchers = vouchers
        self.wallet = wallet
        self.voucherType = voucherType
        super.init()
    }
}

extension VouchersDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch voucherType {
        case .valute:
            return 1
        case .vouchers:
            return vouchers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch voucherType {
        case .valute:
            let cell = tableView.dequeueReusableCell(withIdentifier: "valuteCell", for: indexPath) as! ValuteTableViewCell
            cell.wallet = self.wallet?.wallet
//            cell.sendButton.addTarget(self, action: #selector(send(_:)), for: .touchUpInside)
            return cell
        case .vouchers:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VoucherTableViewCell
            let voucher = vouchers[indexPath.row]
            cell.setupVoucher(voucher: voucher)
            
            return cell
        }
    }
}
