//
//  ItemManager.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/3/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

class ItemManager<T: ItemProtocol>: ItemListHolder{
    var arrayOfItems: [ItemProtocol]
    init(_ array: [T]) {
        self.arrayOfItems = array
    }
}
