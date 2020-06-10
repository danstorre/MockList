//
//  APIClient.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 5/30/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

class APIClient<T: ItemProtocol>: APIProtocol {
    lazy var session: DataTaskCreatorProtocol = URLSession.shared
    var parser: JsonParser<[T]>?
    
    func getItems(completion: @escaping (ItemlListHandler)){
        guard let url = URL(string: "http://private-f0eea-mobilegllatam.apiary-mock.com/list") else {
            fatalError()
        }
        
        let task = session.dataTask(with: url) {[weak self] (data, response, error) in
            
            guard error == nil else {
                completion(nil, WebserviceError.ResponseError)
                return
            }
            
            guard let data = data else {
                completion(nil, WebserviceError.DataEmptyError)
                return
            }
            
            do {
                let items = try self?.parser?.decode(data: data)
                completion(items, nil)
            }catch ItemError.ErrorImageUrlIsNotValid{
                completion(nil, WebserviceError.InvalidImageURLError)
            }catch let error {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
