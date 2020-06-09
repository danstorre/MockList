//
//  ControlFlow.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/9/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class NavigationFlowSelection: SelectableCollection {
    var selectableItems: [ISelectable] = []
    let navControler: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navControler = navigationController
    }
    
    func getSelectableItemAt(indexPath : IndexPath) -> ISelectable? {
        guard !selectableItems.isEmpty,
            selectableItems.indices.contains(indexPath.row) else {
                return nil
        }
        return selectableItems[indexPath.row]
    }
}
