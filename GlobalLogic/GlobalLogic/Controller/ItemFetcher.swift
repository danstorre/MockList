//
//  ItemFetcher.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/1/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol APIProtocol {
    typealias ItemlListHandler = ([Item]?, Error?) -> Void
    typealias DataHandler = (Data?, Error?) -> Void
    func getItems(completion: @escaping (ItemlListHandler))
    func fetchData(from: URL, completion: @escaping(DataHandler))
}

extension APIProtocol {
    func fetchData(from url: URL, completion: @escaping((Data?,Error?)->Void)){
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    completion(data, nil)
                }
            }catch let e{
                DispatchQueue.main.async {
                    completion(nil,e)
                }
            }
        }
    }
}

extension ListTableViewController: ItemFetcherDelegate{
    func didFinish(with error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: "ServiceError", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ok",
                                   style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func didFinish() {
        tableView.reloadData()
    }
}

protocol ItemFetcherDelegate: class{
    func didFinish(with error: Error)
    func didFinish()
}

enum ItemFetcherError: Error {
    case EmptyItemsFromService
}

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
            DispatchQueue.main.async {
            guard let imageData = imageData,
                let image = UIImage(data: imageData) else { completion(nil); return }
                completion(image)
            }
        })
    }
}
