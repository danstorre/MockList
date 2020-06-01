//
//  ItemDataSource.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/1/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol ItemPresentable: class{
    var arrayOfItems: [Item] {get set}
}

class ItemDataSource: ItemLisDataSource{
    
    var presentableItem: ItemPresentable
    
    init(presenting presentableItem: ItemPresentable){
        self.presentableItem = presentableItem
    }
    
    func getThumnailURL(at index: Int) -> URL? {
        guard !presentableItem.arrayOfItems.isEmpty,
            presentableItem.arrayOfItems.indices.contains(index) else {
            return nil
        }
        return presentableItem.arrayOfItems[index].thumbnail
    }
    
    func getNumberOfRows(section: Int) -> Int {
        return presentableItem.arrayOfItems.count
    }
    
    func getItemAndDescriptionTuple(at index: Int) -> (String, String) {
        guard !presentableItem.arrayOfItems.isEmpty,
            presentableItem.arrayOfItems.indices.contains(index) else {
            return ("","")
        }
        let item = presentableItem.arrayOfItems[index]
        return (item.title, item.description)
    }
}
