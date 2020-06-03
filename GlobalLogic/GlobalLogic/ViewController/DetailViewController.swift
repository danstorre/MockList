//
//  DetailViewController.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/3/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, DetailVcProtocol {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var selectedItem: ItemProtocol?
    var fetcher: ImageFetcher?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = selectedItem?.title
        descriptionLabel.text = selectedItem?.description
        
        if let imageUrl = selectedItem?.thumbnail {
            configureImageViewWith(url: imageUrl)
        } else {
            hideImageView()
        }
    }
    
    private func configureImageViewWith(url imageUrl: URL) {
        fetcher?.fetchImage(from: imageUrl, completion: {[weak self] (image) in
            if let image = image {
                self?.imageView.image = image
            } else {
                self?.hideImageView()
            }
        })
    }
    
    private func hideImageView(){
        imageView.isHidden = true
    }
}
