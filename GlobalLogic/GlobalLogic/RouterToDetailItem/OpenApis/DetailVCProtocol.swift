//
//  DetailVCProtocol.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

protocol DetailVcProtocol: UIViewController {
    var titleLabel: UILabel! { get set }
    var descriptionLabel: UILabel! { get set }
    var imageView: UIImageView! {get set}
    var fetcher: ImageFetcher? {get set}
    var selectedItem: ItemProtocol? {get set}
}
