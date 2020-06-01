//
//  ItemDataSource.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/1/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol ItemListHolder: class{
    var arrayOfItems: [Item] {get set}
}

class ItemDataSource: ItemLisDataSource{
    
    var itemListHolder: ItemListHolder
    
    init(presenting itemListHolder: ItemListHolder){
        self.itemListHolder = itemListHolder
    }
    
    func getThumnailURL(at index: Int) -> URL? {
        guard !itemListHolder.arrayOfItems.isEmpty,
            itemListHolder.arrayOfItems.indices.contains(index) else {
            return nil
        }
        return itemListHolder.arrayOfItems[index].thumbnail
    }
    
    func getNumberOfRows(section: Int) -> Int {
        return itemListHolder.arrayOfItems.count
    }
    
    func getItemAndDescriptionTuple(at index: Int) -> (String, String) {
        guard !itemListHolder.arrayOfItems.isEmpty,
            itemListHolder.arrayOfItems.indices.contains(index) else {
            return ("","")
        }
        let item = itemListHolder.arrayOfItems[index]
        return (item.title, item.description)
    }
}
