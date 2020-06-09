//
//  ListTableViewController.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 5/31/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

struct UrlFetcher: URLFetcher {}

protocol ImageFetcher {
    typealias ImageHandler = ((UIImage?) -> Void)
    func fetchImage(from: URL, completion: @escaping(ImageHandler))
}

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

protocol ItemListFetcher: ImageFetcher {
    func fetchItems()
}

protocol ItemLisDataSource {
    func getThumnailURL(at: Int) -> URL?
    func getNumberOfRows(section: Int) -> Int
    func getItemAndDescriptionTuple(at: Int) -> (String, String)
}

protocol SelectableCollection {
    func getSelectableItemAt(indexPath: IndexPath) -> ISelectable?
}

class ListTableViewController: UITableViewController {
    
    var fetcher: ItemListFetcher!
    var dataSource: ItemLisDataSource!
    var selectionDelegate: SelectableCollection?
    
    private lazy var imagePlaceHolder = UIImage(named: "icono")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetcher.fetchItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.reloadData()
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.getNumberOfRows(section: 0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell",
                                                 for: indexPath) as! ItemCell
        
        //configure the cell
        //get thumbnail from fetcher if needed.
        
        let (title,description) = dataSource.getItemAndDescriptionTuple(at: indexPath.row)
        cell.configuresCellWith(title: title, and: description)
        
        if let thumnailURL = dataSource.getThumnailURL(at: indexPath.row) {
            fetcher.fetchImage(from: thumnailURL, completion: {[weak self] (image) in
                if let image = image {
                    cell.configureThumnail(with: image)
                } else {
                    guard let self = self else {return}
                    self.configurePlaceHolderTo(cell)
                }
            })
        } else {
            configurePlaceHolderTo(cell)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        configurePlaceHolderTo(cell as! ItemCell)
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectionDelegate?.getSelectableItemAt(indexPath: indexPath)?.select()
    }
    
    private func configurePlaceHolderTo(_ cell: ItemCell) {
        cell.configureThumnail(with: self.imagePlaceHolder)
    }
}
