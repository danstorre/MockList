//
//  SceneDelegate.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 5/29/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var itemManager: ItemListHolder?
    var modelObservers: IObserverMediator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        let items = configureModelAndObservers()
        let listvc = createListVc()
        let fetcher = createFetcher(for: listvc)
        
        listvc.dataSource = ItemDataSource(presenting: itemManager!)
        listvc.fetcher = fetcher
        
        let navController = UINavigationController()
        let detailUseCase = createDetailUseCaseImpl(with: navController)
        let controlFlow = NavigationDetailFlowSelection(router: detailUseCase)
        
        (items.observer as? ObserverCollection)?.addObserver(observer: controlFlow)
        listvc.selectionDelegate = controlFlow
        
        navController.viewControllers.append(listvc)
        
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    func createDetailUseCaseImpl(with navController: UINavigationController) -> NavigationDetailsUseCase  {
        return RoutesToDetailItemViewController(navigationController: navController)
    }
    
    func createFetcher(for delegate: ItemFetcherDelegate) -> ItemListFetcher {
        let apiService = APIClient<Item>()
        apiService.parser = JsonParser()
        let fetcher = ItemFetcher(itemListHolder: itemManager!,
                                  apiService: apiService)
        fetcher.delegate = delegate
        return fetcher
    }
    
    func createListVc() -> ListTableViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listvc = storyboard.instantiateViewController(withIdentifier: "ListTableViewController") as! ListTableViewController
        return listvc
    }

    func configureModelAndObservers() -> ItemManager<Item> {
        modelObservers = ObserverMediator()
        let items = ItemManager([Item]())
        items.observer = modelObservers
        itemManager = items
        return items
    }


}

