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

protocol ItemProtocol: Decodable {
    var title: String {get set}
    var description: String {get set}
    var thumbnail: URL? {get set}
}

struct Item: ItemProtocol{
    var title: String
    var description: String
    var thumbnail: URL?
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case thumbnail = "image"
    }
    
    init(title: String, description: String, thumbnail: URL) {
        self.init(title: title, description: description)
        self.thumbnail = thumbnail
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
        
        let admittedHosts = ["picsum.photos","picsum.photos.ar"]
        if let url = URL(string: urlString),
            let componentes = URLComponents(url: url, resolvingAgainstBaseURL: false),
            componentes.scheme == "https", let host = componentes.host, admittedHosts.contains(host){
            thumbnail = url
        }else {
            throw ItemError.ErrorImageUrlIsNotValid
        }
        
    }
    
}


