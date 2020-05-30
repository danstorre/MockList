//
//  APIClient.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 5/30/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

enum WebserviceError : Error {
    case DataEmptyError
    case InvalidImageURLError
    case ResponseError
}

protocol DataTaskCreatorProtocol {
    func dataTask(with url: URL,
                  completionHandler:
        @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: DataTaskCreatorProtocol{}

class APIClient {
    lazy var session: DataTaskCreatorProtocol = URLSession.shared
    typealias ItemlListHandler = ([Item]?, Error?) -> Void
    
    func getItems(completion: @escaping (ItemlListHandler)){
        guard let url = URL(string: "http://private-f0eea-mobilegllatam.apiary-mock.com/list") else {
            fatalError()
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(nil, WebserviceError.ResponseError)
                return
            }
            
            guard let data = data else {
                completion(nil, WebserviceError.DataEmptyError)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let items = try jsonDecoder
                    .decode([Item].self, from: data)
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
