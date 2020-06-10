//
//  ItemDataSourceProtocol.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol ItemLisDataSource {
    func getThumnailURL(at: Int) -> URL?
    func getNumberOfRows(section: Int) -> Int
    func getItemAndDescriptionTuple(at: Int) -> (String, String)
}
