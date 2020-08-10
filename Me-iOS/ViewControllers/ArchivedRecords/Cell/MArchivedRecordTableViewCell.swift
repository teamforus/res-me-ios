//
//  MArchivedRecordTableViewCell.swift
//  Me-iOS
//
//  Created by Inga Codreanu on 24.07.20.
//  Copyright © 2020 Tcacenco Daniel. All rights reserved.
//

import UIKit

class MArchivedRecordTableViewCell: UITableViewCell {
    private var typeRecord: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 13)
        label.textColor = #colorLiteral(red: 0.5150660276, green: 0.5296565294, blue: 0.5467811227, alpha: 1)
        return label
    }()
    
    private var valueRecord: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = UIFont(name: "GoogleSans-Medium", size: 18)
        return label
    }()
    
    private var archivedLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 14)
        label.textColor = #colorLiteral(red: 0.5150660276, green: 0.5296565294, blue: 0.5467811227, alpha: 1)
        label.text = "Archived"
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "GoogleSans-Regular", size: 14)
        label.textColor = #colorLiteral(red: 0.5150660276, green: 0.5296565294, blue: 0.5467811227, alpha: 1)
        label.isHidden = true
        return label
    }()
    
    private var separator: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = #colorLiteral(red: 0.9502839446, green: 0.9651113153, blue: 0.9734370112, alpha: 1)
        return view
    }()
    
    static let indentifier = "MArchivedRecordTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        addCnstraints()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(record: Record?) {
        guard let record = record else { return }
        typeRecord.text = record.name
        valueRecord.text = record.value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        typeRecord.text = ""
        valueRecord.text = ""
        dateLabel.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

 // MARK: - Setup Views

extension MArchivedRecordTableViewCell {
    func addSubviews() {
        let views = [typeRecord, valueRecord, archivedLabel, separator]
        views.forEach { (view) in
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func addCnstraints() {
        NSLayoutConstraint.activate([
            typeRecord.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 17),
            typeRecord.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 18),
            typeRecord.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -17)
        ])
        
        NSLayoutConstraint.activate([
            valueRecord.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 17),
            valueRecord.topAnchor.constraint(equalTo: typeRecord.bottomAnchor, constant: 5),
            valueRecord.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -17)
        ])
        
        NSLayoutConstraint.activate([
            archivedLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 17),
            archivedLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            archivedLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -17)
        ])
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            separator.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            separator.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0)
        ])
    }
}
