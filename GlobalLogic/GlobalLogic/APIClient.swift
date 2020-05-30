//
//  APIClient.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 5/30/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation


protocol DataTaskCreatorProtocol {
    func dataTask(with url: URL,
                  completionHandler:
        @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: DataTaskCreatorProtocol{}

class APIClient {
    lazy var session: DataTaskCreatorProtocol = URLSession.shared
    typealias ItemlListHandler = ([Item]?) -> Void
    
    func getItems(completion: @escaping (ItemlListHandler)){
        guard let url = URL(string: "http://private-f0eea-mobilegllatam.apiary-mock.com/list") else {
            fatalError()
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
            if let items = try? jsonDecoder.decode([Item].self,
                                              from: data!) {
                completion(items)
            }
            
        }
        task.resume()
    }
}
