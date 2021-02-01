//
//  MTransactionsViewController.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 29.08.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MTransactionsViewController: UIViewController {
    
    lazy var transactionViewModel: TransactionViewModel = {
        let viewModel = TransactionViewModel()
        viewModel.vc = self
        return viewModel
    }()
    
    private var transaction: [Transaction] = []
    private let cellHeight: CGFloat = 89
    
    // MARK: - Properties
    private let headerView: Background_DarkMode = {
        let view = Background_DarkMode()
        view.colorName = "DarkGray_DarkTheme"
        return view
    }()
    
    private let backButton: BackButton_DarkMode = {
        let button = BackButton_DarkMode()
        button.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.text = Localize.transactions()
        label.font = UIFont(name: "GoogleSans-Medium", size: 38)
        return label
    }()
    
    private let dateButton: ShadowButton = {
        let button = ShadowButton()
        button.addTarget(self, action: #selector(openDatePicker), for: .touchUpInside)
        button.corner = 9
        button.colorName = "VoucherButton"
        button.colorNameTitle = "Blue_DarkTheme"
        button.titleLabel?.font = R.font.googleSansRegular(size: 14)
        return button
    }()
    
    private let tableView: TableView_Background_DarkMode = {
        let tableView = TableView_Background_DarkMode()
        return tableView
    }()
    
    private let bottomView: Background_DarkMode = {
        let view = Background_DarkMode()
        view.colorName = "Background_DarkTheme"
        return view
    }()
    
    private let totalPriceView: Background_DarkMode = {
        let view = Background_DarkMode()
        view.colorName = "Background_DarkTheme"
        view.isHidden = true
        return view
    }()
    
    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let totalLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.text = "Totaal"
        label.font = UIFont(name: "GoogleSans-Regular", size: 15)
        return label
    }()
    
    private let priceTotalLabel: UILabel_DarkMode = {
        let label = UILabel_DarkMode()
        label.textColor = #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1)
        label.text = "€ 2.008,09"
        label.font = UIFont(name: "GoogleSans-Regular", size: 15)
        return label
    }()
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var datePicker : MDatePickerView = {
        let mdate = MDatePickerView()
        mdate.Color = #colorLiteral(red: 0.1702004969, green: 0.3387943804, blue: 1, alpha: 1)
        mdate.delegate = self
        mdate.translatesAutoresizingMaskIntoConstraints = false
        mdate.from = 2016
        mdate.to = 2100
        return mdate
    }()
    
  lazy var datePickerNew : UIDatePicker = {
      let mdate = UIDatePicker()
      mdate.translatesAutoresizingMaskIntoConstraints = false
      if #available(iOS 14.0, *) {
        mdate.backgroundColor = .clear
        mdate.preferredDatePickerStyle = .compact
        mdate.datePickerMode = .date
        mdate.addTarget(self, action: #selector(getDate(from:)), for: .valueChanged)
        } else {
        // Fallback on earlier versions
      }
     return mdate
  }()
   
  var gestorRecognizer = UIGestureRecognizer()
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        addSubviews()
        setupConstraints()
        setupView()
        setupTableView()
        fetchTransaction()
        fetchComplete()
      datePickerNew.subviews.forEach { (view) in
        view.subviews.forEach { (view) in
          view.subviews.forEach { (view) in
            view.removeFromSuperview()
          }
        }
      }
     
    }
    
}

// MARK: - Setup View

extension MTransactionsViewController {
    func setupView() {
        dateButton.setTitle(Localize.choose_from_date(), for: .normal)
        if #available(iOS 11.0, *) {
            self.view.backgroundColor = UIColor(named: "Background_DarkTheme")
        } else {
        }
    }
    
    func addSubviews() {
        let views = [headerView ,tableView, bottomView, totalPriceView ]
     
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        addHeaderViewSubviews()
        addBottomViewSubviews()
      if #available(iOS 14.0, *) {
        view.addSubview(datePickerNew)
        } else {
         
      }
     
    }
    
    func addHeaderViewSubviews() {
        let views = [backButton, titleLabel, dateButton]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.headerView.addSubview(view)
        }
    }
    
    func addBottomViewSubviews() {
        let views = [topLineView, bottomLineView, totalLabel, priceTotalLabel]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.totalPriceView.addSubview(view)
        }
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(TransactionListTableViewCell.self, forCellReuseIdentifier: TransactionListTableViewCell.identifier)
    }
}

// MARK: - Setup Constraints

extension MTransactionsViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: 210),
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            dateButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            dateButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
            dateButton.heightAnchor.constraint(equalToConstant: 44),
            dateButton.widthAnchor.constraint(equalToConstant: 200)
        ])
      
      
//      NSLayoutConstraint.activate([
//        datePickerNew.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
//        datePickerNew.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
//        datePickerNew.heightAnchor.constraint(equalToConstant: 44),
//        datePickerNew.widthAnchor.constraint(equalToConstant: 200)
//      ])
      
        
//        NSLayoutConstraint.activate([
//            totalPriceView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 18),
//            totalPriceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            totalPriceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            totalPriceView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -28),
//            totalPriceView.heightAnchor.constraint(equalToConstant: 50)
//        ])
//
//        NSLayoutConstraint.activate([
//            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
//            bottomView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0)])
        
       
        
        setupConstraintsHeaderView()
        setupConstraintsBottomView()
    }
    
    func setupConstraintsHeaderView() {
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 90),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 17)
        ])
    }
    
    func setupConstraintsBottomView() {
        NSLayoutConstraint.activate([
            topLineView.topAnchor.constraint(equalTo: totalPriceView.topAnchor, constant: 0),
            topLineView.leadingAnchor.constraint(equalTo: totalPriceView.leadingAnchor, constant: 0),
            topLineView.trailingAnchor.constraint(equalTo: totalPriceView.trailingAnchor, constant: 0),
            topLineView.heightAnchor.constraint(equalToConstant: 1)
            
        ])
        
        NSLayoutConstraint.activate([
            totalLabel.centerYAnchor.constraint(equalTo: totalPriceView.centerYAnchor, constant: 0),
            totalLabel.leadingAnchor.constraint(equalTo: totalPriceView.leadingAnchor, constant: 24)
        ])
        
        NSLayoutConstraint.activate([
            priceTotalLabel.centerYAnchor.constraint(equalTo: totalPriceView.centerYAnchor, constant: 0),
            priceTotalLabel.trailingAnchor.constraint(equalTo: totalPriceView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            bottomLineView.bottomAnchor.constraint(equalTo: totalPriceView.bottomAnchor, constant: 0),
            bottomLineView.leadingAnchor.constraint(equalTo: totalPriceView.leadingAnchor, constant: 0),
            bottomLineView.trailingAnchor.constraint(equalTo: totalPriceView.trailingAnchor, constant: 0),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

// MARK: - Fetch Transaction

extension MTransactionsViewController {
    func fetchTransaction() {
        if isReachable() {
            KVSpinnerView.show()
            transactionViewModel.vc = self
            transactionViewModel.initFetch()
        }else {
            showInternetUnable()
        }
    }
    
    func fetchComplete() {
        transactionViewModel.complete = { [weak self] (_) in
            DispatchQueue.main.async {
               
                self?.tableView.reloadData()
                KVSpinnerView.dismiss()
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension MTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionListTableViewCell.identifier, for: indexPath) as? TransactionListTableViewCell else { return UITableViewCell() }
        
        let transaction = transactionViewModel.getCellViewModel(at: indexPath)
        cell.configure(transaction: transaction)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = transactionViewModel.getCellViewModel(at: indexPath)
        openTransactionOverview(with: transaction)
        
    }
}

// MARK: - MDatePickeDelegate

extension MTransactionsViewController: MDatePickerViewDelegate {
    func mdatePickerView(selectDate: Date) {
      dateButton.setTitle("From date: " + selectDate.dateFormaterFromDateShort(), for: .normal)
        transactionViewModel.sortTransactionByDate(form: selectDate)
    }
}

// MARK: - Actions

extension MTransactionsViewController {
    func openTransactionOverview(with transaction: Transaction) {
        let transactionOverview = TransactionOverview()
        setupTrasactionOverview(transactionOverview: transactionOverview)
        transactionOverview.configure(transaction: transaction)
        transactionOverview.popIn()
    }
    
    func setupTrasactionOverview(transactionOverview: TransactionOverview) {
        transactionOverview.translatesAutoresizingMaskIntoConstraints = false
        transactionOverview.backgroundColor = .clear
        self.view.addSubview(transactionOverview)
        NSLayoutConstraint.activate([
            transactionOverview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            transactionOverview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            transactionOverview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            transactionOverview.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        ])
    }
    
     @objc func openDatePicker() {
        if #available(iOS 14.0, *) {
        datePickerNew.showAnimate()
        setupDatePickerNewConstraints()
        } else {
          view.addSubview(datePicker)
          setupDatePickerConstraints()
          datePicker.showAnimate()
      }
   }
    
    func setupDatePickerConstraints() {
        NSLayoutConstraint.activate([
          datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
          datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
          datePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
          datePicker.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
    }
  
  func setupDatePickerNewConstraints() {
    NSLayoutConstraint.activate([
    datePickerNew.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
    datePickerNew.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
    datePickerNew.heightAnchor.constraint(equalToConstant: 44),
    datePickerNew.widthAnchor.constraint(equalToConstant: 200)
    ])
  }
  
  
  @objc func getDate(from datePiker:UIDatePicker) {
    dateButton.setTitle("From date: " + datePiker.date.dateFormaterFromDateShort(), for: .normal)
    transactionViewModel.sortTransactionByDate(form: datePiker.date)
    self.dismiss(UIButton())
  }
}
