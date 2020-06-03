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
    var fetcher: URLFetcher?
    
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
        fetcher?.fetchData(from: imageUrl, completion: { [weak self] (data, error) in
            
            guard error == nil else{
                self?.hideImageView()
                return
            }
            
            if let data = data {
                self?.imageView.image = UIImage(data: data)
            } else {
                self?.hideImageView()
            }
        })
    }
    
    private func hideImageView(){
        imageView.isHidden = true
    }
}
