//
//  UrlFetcher+Extension.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

extension URLFetcher {
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
