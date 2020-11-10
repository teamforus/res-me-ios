//
//  OrganizationValidatorViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 10/21/19.
//  Copyright © 2019 Tcacenco Daniel. All rights reserved.
//

import UIKit

protocol OrganizationValidatorViewControllerDelegate: class {
    func close()
    func selectOrganization(organization: EmployeesOrganization, vc: UIViewController)
    func selectOrganizationVoucher(organization: AllowedOrganization, vc: UIViewController)
}

enum OrganizationListType {
    case recordOrganization, subsidieOrganization
}

class OrganizationValidatorViewController: UIViewController {
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bodyView: CustomCornerUIView!
    @IBOutlet weak var bottomConstraintView: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    
    var organizationType: OrganizationListType = .recordOrganization
    weak var delegate: OrganizationValidatorViewControllerDelegate!
    var recordEmployeesOrganizations: [EmployeesOrganization] = []
    var allowedOrganization: [AllowedOrganization] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAccessibility()
        setupView()
    }
    
    func setupView() {
        setupTitle()
        self.blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close(_:))))
        tableView.register(UINib(nibName: "OrganizationValidatorTableViewCell", bundle: nil), forCellReuseIdentifier: "OrganizationValidatorTableViewCell")
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.bottomConstraintView.constant = -12
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func setupTitle() {
        switch organizationType {
        case .recordOrganization:
            self.titleLabel.text = Localize.choose_validator()
        case .subsidieOrganization:
            self.titleLabel.text = Localize.choose_organization()
        }
    }
    
    @IBAction func close(_ sender: UIButton){
        bottomConstraintView.constant = -1000
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (isFinished) in
            self.view.removeFromSuperview()
            self.delegate.close()
        })
    }
    
}

extension OrganizationValidatorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch organizationType {
        case .recordOrganization:
            return recordEmployeesOrganizations.count
        case .subsidieOrganization:
            return allowedOrganization.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationValidatorTableViewCell", for: indexPath) as! OrganizationValidatorTableViewCell
        
        switch organizationType {
        case .recordOrganization:
            cell.setupRecordOrganization(organization: recordEmployeesOrganizations[indexPath.row])
        case .subsidieOrganization:
            cell.setupVoucherOrganization(organization: allowedOrganization[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch organizationType {
        case .recordOrganization:
            delegate.selectOrganization(organization: recordEmployeesOrganizations[indexPath.row], vc: self)
        case .subsidieOrganization:
            delegate.selectOrganizationVoucher(organization: allowedOrganization[indexPath.row], vc: self)
        }
        close(closeButton)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !tableView.isCellVisible(section: 0, row: recordEmployeesOrganizations.count - 1) {
            heightConstraint.constant = self.view.frame.size.height
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Accessibility Protocol

extension OrganizationValidatorViewController: AccessibilityProtocol {
    func setupAccessibility() {
        closeButton.setupAccesibility(description: "Close", accessibilityTraits: .button)
    }
}

extension UITableView {
    func isCellVisible(section:Int, row: Int) -> Bool {
        guard let indexes = self.indexPathsForVisibleRows else {
            return false
        }
        return indexes.contains {$0.section == section && $0.row == row }
    }  }
