//
//  RecordsDataSource.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 24.05.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class RecordsDataSource: NSObject {
    var records: [Record]
    
    init(records: [Record]) {
        self.records = records
        super.init()
    }
}

extension RecordsDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecordsTableViewCell
        
        cell.record = records[indexPath.row]
        return cell
    }
}
