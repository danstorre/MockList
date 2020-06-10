//
//  ItemProtocol.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol ItemProtocol: Decodable {
    var title: String {get set}
    var description: String {get set}
    var thumbnail: URL? {get set}
}
