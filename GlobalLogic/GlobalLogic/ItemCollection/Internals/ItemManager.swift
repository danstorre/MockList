//
//  ItemManager.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/3/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

class ItemManager<T: ItemProtocol>: ItemListHolder{
    
    var arrayOfItems: [ItemProtocol] {
        willSet(newValue) {
            observer?.willChange(propertyName: ItemManagerKeys.arrayOfItems, newPropertyValue: newValue)
        }
        didSet {
            observer?.didChange(propertyName: ItemManagerKeys.arrayOfItems, oldPropertyValue: oldValue)
        }
    }
    
    weak var observer:PropertyObserver?
    
    init(_ array: [T]) {
        self.arrayOfItems = array
    }
}
