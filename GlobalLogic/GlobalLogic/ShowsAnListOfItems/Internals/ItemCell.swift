//
//  ItemCell.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 5/31/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet var titleItem: UILabel!
    @IBOutlet var descriptionItem: UILabel!
    @IBOutlet var thumnailImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configuresCellWith(title: String, and description: String) {
        titleItem.text = title
        descriptionItem.text = description
    }
    
    func configureThumnail(with image: UIImage){
        self.thumnailImageView.image = image
    }
}
