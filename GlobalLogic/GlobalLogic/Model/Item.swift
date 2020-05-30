//
//  Item.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 5/29/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

enum ItemError: Error{
    case ErrorImageUrlIsNotValid
}

struct Item: Decodable{
    var title: String
    var description: String
    var thumbnail: URL?
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case thumbnail = "image"
    }
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        
        guard let urlString =
            try values.decodeIfPresent(String.self,
                                       forKey: .thumbnail)
            else { return }
        
        
        if let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url) {
            thumbnail = url
        }else {
            throw ItemError.ErrorImageUrlIsNotValid
        }
        
    }
    
}

