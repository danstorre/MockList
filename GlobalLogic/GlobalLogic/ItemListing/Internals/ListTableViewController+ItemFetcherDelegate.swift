//
//  ListTableViewController+ItemFetcherDelegate.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

extension ListTableViewController: ItemFetcherDelegate{
    func didFinish(with error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: "ServiceError", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ok",
                                   style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func didFinish() {
        tableView.reloadData()
    }
}
