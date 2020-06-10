//
//  NavigationsToItem.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

struct RoutesToDetailItemViewController: NavigationDetailsUseCase {
    var navigationController: UINavigationController?
    func gotoDetail(withItem selectedItem: ItemProtocol) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vcDetail = storyBoard.instantiateViewController(identifier: "DetailViewController") as? DetailVcProtocol else {
            fatalError("DetailViewController is not configured in main story board.")
        }
        vcDetail.selectedItem = selectedItem
        vcDetail.fetcher = ImageService()
        
        navigationController?.pushViewController(vcDetail, animated: true)
    }
}
