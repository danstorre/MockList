//
//  DetailItemRouter.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/3/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol HasNavigationController {
    var navigationController: UINavigationController? {get set}
}

typealias DetailItemVcPresenter = HasNavigationController & RouterDetailItemProtocol

class DetailItemRouter: DetailItemVcPresenter{
    var navigationController: UINavigationController?
    var selectedItem: ItemProtocol?
    
    init(_ navigationController: UINavigationController? = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    func present() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard var vcDetail = storyBoard.instantiateViewController(identifier: "DetailViewController") as? DetailVcProtocol else {
            fatalError("DetailViewController is not configured in main story board.")
        }
        vcDetail.selectedItem = selectedItem
        
        navigationController?.pushViewController(vcDetail, animated: false)
    }
}

protocol DetailVcProtocol: UIViewController, HasSelectedItemProtocol{
}