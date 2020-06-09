//
//  NavigationFlow+PropertyObserver.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/9/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension NavigationDetailFlowSelection: PropertyObserver {
    func willChange(propertyName: String, newPropertyValue: Any?) {
        if propertyName == ItemManagerKeys.arrayOfItems,
            let items = newPropertyValue as? [ItemProtocol] {
            selectableItems = items.map { (item) -> NavigatesToItemDetails in
                return NavigatesToItemDetails(item: item,
                                              router: router)
            }
        }
    }
    
    func didChange(propertyName: String, oldPropertyValue: Any?) {
    }
}
