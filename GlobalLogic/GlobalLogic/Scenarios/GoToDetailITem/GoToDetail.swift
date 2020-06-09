//
//  GoToDetail.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/8/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol NavigationDetailsUseCase{
    func gotoDetail(withItem: ItemProtocol)
}

protocol ISelectable {
    func select()
}

protocol SelectableHoldableItem: ISelectable{
    var item: ItemProtocol { get set }
}

protocol SelectableItemRouterDelegatable:  SelectableHoldableItem{
    var router: NavigationDetailsUseCase? {get set}
}

struct NavigatesToItemDetails: SelectableItemRouterDelegatable{
    var item: ItemProtocol
    var router: NavigationDetailsUseCase?
    
    func select() {
        router?.gotoDetail(withItem: item)
    }
}

struct RoutesToDetailItemViewController: NavigationDetailsUseCase {
    var navigationController: UINavigationController?
    func gotoDetail(withItem selectedItem: ItemProtocol) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard var vcDetail = storyBoard.instantiateViewController(identifier: "DetailViewController") as? DetailVcProtocol else {
            fatalError("DetailViewController is not configured in main story board.")
        }
        vcDetail.selectedItem = selectedItem
        vcDetail.fetcher = ImageService()
        
        navigationController?.pushViewController(vcDetail, animated: true)
    }
}
