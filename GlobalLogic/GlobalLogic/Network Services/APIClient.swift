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

protocol ParserProtocol {
    associatedtype T: Decodable
    func decode(data: Data) throws -> T
}

class JsonParser<DecodableType: Decodable>: ParserProtocol{
    typealias T = DecodableType
    
    func decode(data: Data) throws -> T {
        let jsonDecoder = JSONDecoder()
        let items = try jsonDecoder.decode(T.self, from: data)
        return items
    }
}

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
