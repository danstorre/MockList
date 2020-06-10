//
//  GoToDetail.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/8/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

struct NavigatesToItemDetails: ISelectable{
    var item: ItemProtocol
    var router: NavigationDetailsUseCase
    
    func select() {
        router.gotoDetail(withItem: item)
    }
}
