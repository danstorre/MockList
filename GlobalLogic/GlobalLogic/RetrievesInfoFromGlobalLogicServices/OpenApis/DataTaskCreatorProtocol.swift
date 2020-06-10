//
//  DataTaskCreatorProtocol.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol DataTaskCreatorProtocol {
    func dataTask(with url: URL,
                  completionHandler:
        @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
