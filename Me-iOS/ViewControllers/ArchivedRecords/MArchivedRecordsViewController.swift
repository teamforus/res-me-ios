//
//  MArchivedRecordsViewController.swift
//  Me-iOS
//
//  Created by Inga Codreanu on 24.07.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit
import KVSpinnerView

class MArchivedRecordsViewController: UIViewController {
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Medium", size: 38)
        label.textColor = .black
        label.text = "Archived records"
        return label
    }()
    
    private var backButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        button.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var recordViewModel: RecordsViewModel = {
        let recordViewModel = RecordsViewModel()
        recordViewModel.isArchived = true
        return recordViewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        addSubviews()
        addConstraints()
        initFetch()
        fetchArchivedRecords()
    }
    
    func fetchArchivedRecords() {
        recordViewModel.complete = { [weak self] (records) in
            
            DispatchQueue.main.async {
                
                self?.tableView.reloadData()
                KVSpinnerView.dismiss()
            }
        }
    }
    
    func initFetch() {
        if isReachable() {
            KVSpinnerView.show()
            recordViewModel.vc = self
            recordViewModel.initFitch()
        }else {
            showInternetUnable()
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MArchivedRecordTableViewCell.self, forCellReuseIdentifier: MArchivedRecordTableViewCell.indentifier)
    }
}

 // MARK: - UITableViewDelegate

extension MArchivedRecordsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MArchivedRecordTableViewCell.indentifier, for: indexPath) as? MArchivedRecordTableViewCell else { return UITableViewCell() }
        cell.configure(record: recordViewModel.getCellViewModel(at: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
}

 // MARK: - Setup UI

extension MArchivedRecordsViewController {
    
    func setupUI() {
        self.view.backgroundColor = .white
    }
    
    func addSubviews() {
        let views = [tableView, titleLabel, backButton]
        views.forEach { (view) in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 154),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 43),
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5)
        ])
    }
}
