//
//  Router.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/3/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol Selectable {
    func selectsItem(at: Int)
}
protocol HasItemListHolder{
    var itemListHolder: ItemListHolder {get set}
}

protocol HasRouter{
    var router: RouterDetailItemProtocol { get set }
}

protocol RouterProtocol {
    func present()
}

protocol HasSelectedItemProtocol {
    var selectedItem: ItemProtocol? {get set}
}

typealias RouterDetailItemProtocol = RouterProtocol & HasSelectedItemProtocol
typealias ItemSelectable = Selectable & HasItemListHolder
typealias ItemSelectableNavigatable = ItemSelectable & HasRouter

class ItemNavigationController: ItemSelectableNavigatable{
    var itemListHolder: ItemListHolder
    var router: RouterDetailItemProtocol
    
    init(router: RouterDetailItemProtocol,
         itemListHolder: ItemListHolder) {
        self.router = router
        self.itemListHolder = itemListHolder
    }
    
    func selectsItem(at index: Int) {
        guard !itemListHolder.arrayOfItems.isEmpty,
            itemListHolder.arrayOfItems.indices.contains(index) else {
                return
        }
        router.selectedItem = itemListHolder.arrayOfItems[index]
        router.present()
    }
}




