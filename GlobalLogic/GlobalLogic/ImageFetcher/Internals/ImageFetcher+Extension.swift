//
//  ImageFetcher+Extension.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

extension ImageFetcher {
    func fetchImage(from url: URL, completion: @escaping((UIImage?) -> Void)) {
        UrlFetcher().fetchData(from: url) { (imageData, error) in
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
        }
    }
}
