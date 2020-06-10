//
//  ItemserviceProtocol.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol APIProtocol: URLFetcher {
    typealias ItemlListHandler = ([ItemProtocol]?, Error?) -> Void
    func getItems(completion: @escaping (ItemlListHandler))
}

