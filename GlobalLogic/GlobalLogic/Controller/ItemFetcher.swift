//
//  ItemFetcher.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/1/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

enum APIProtocolError: Error {
    case FetchedImageNotFound
}

protocol APIProtocol {
    typealias ItemlListHandler = ([ItemProtocol]?, Error?) -> Void
    typealias DataHandler = (Data?, Error?) -> Void
    func getItems(completion: @escaping (ItemlListHandler))
    func fetchData(from: URL, completion: @escaping(DataHandler))
}

extension APIProtocol {
    func fetchData(from url: URL, completion: @escaping((Data?,Error?)->Void)){
        DispatchQueue.global().async {
            guard let downsampleImage = DownSamplerMethods.downsample(imageAt: url),
            let downsampleImageData = downsampleImage.pngData() else{
                DispatchQueue.main.async {completion(nil, APIProtocolError.FetchedImageNotFound)}
                return
            }
            
            DispatchQueue.main.async {
                completion(downsampleImageData, nil)
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
