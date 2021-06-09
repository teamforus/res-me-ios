//
//  ActionsDataSource.swift
//  Me-iOS
//
//  Created by Tcacenco Daniel on 25.05.21.
//  Copyright © 2021 Tcacenco Daniel. All rights reserved.
//

import UIKit

class ActionsDataSource: NSObject {
    var subsidies: [Subsidie]
    var viewModel: ActionViewModel
    var parentVC: MActionsViewController
    
     init(subsidies: [Subsidie], viewModel: ActionViewModel, parentVC: MActionsViewController) {
        self.subsidies = subsidies
        self.viewModel = viewModel
        self.parentVC = parentVC
        super.init()
    }

}

extension ActionsDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subsidies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionTableViewCell.identifier, for: indexPath) as? ActionTableViewCell else {
            return UITableViewCell()
        }
        let subsidie = subsidies[indexPath.row]
        cell.setupActions(subsidie: subsidie)
        
        if subsidies.count - 1 == indexPath.row {
            if viewModel.lastPage != viewModel.currentPage {
                self.parentVC.fetchActions()
            }
        }
        return cell
    }
    
}
