//
//  NavigationFlow+PropertyObserver.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/9/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension NavigationFlowSelection: PropertyObserver {
    func willChange(propertyName: String, newPropertyValue: Any?) {
        if propertyName == ItemManagerKeys.arrayOfItems,
            let items = newPropertyValue as? [ItemProtocol] {
            selectableItems = items.map { (item) -> ISelectable in
                return NavigatesToItemDetails(item: item,
                                              router: RoutesToDetailItemViewController(
                                                navigationController: navControler))
            }
        }
    }
    
    func didChange(propertyName: String, oldPropertyValue: Any?) {
    }
}
