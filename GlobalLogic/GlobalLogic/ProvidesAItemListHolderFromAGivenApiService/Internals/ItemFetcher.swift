//
//  ItemFetcher.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/1/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class ItemFetcher: ItemListFetcher{
    let itemListHolder: ItemListHolder
    let apiService: APIProtocol
    
    weak var delegate: ItemFetcherDelegate?
    
    init(itemListHolder: ItemListHolder, apiService: APIProtocol) {
        self.itemListHolder = itemListHolder
        self.apiService = apiService
    }
    
    func fetchItems() {
        apiService.getItems { [weak self] (items, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self?.delegate?.didFinish(with: error!)
                    return
                }
                
                guard let items = items, !items.isEmpty else {
                    self?.delegate?
                        .didFinish(with:
                            ItemFetcherError.EmptyItemsFromService)
                    return
                }
                
                self?.itemListHolder.arrayOfItems = items
                self?.delegate?.didFinish()
            }
        }
    }
    
    func fetchImage(from url: URL, completion: @escaping ((UIImage?) -> Void)) {
        apiService.fetchData(from: url, completion: {(imageData, error) in
            guard error == nil else{
                DispatchQueue.main.async {completion(nil)}
                return
            }
            guard let imageData = imageData,
            let image = UIImage(data: imageData) else {
                DispatchQueue.main.async {completion(nil)}
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        })
    }
}
