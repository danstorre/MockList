//
//  ImageFetcher.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol ImageFetcher {
    typealias ImageHandler = ((UIImage?) -> Void)
    func fetchImage(from: URL, completion: @escaping(ImageHandler))
}
