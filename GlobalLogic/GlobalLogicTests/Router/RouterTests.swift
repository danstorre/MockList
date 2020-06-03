//
//  RouterTests.swift
//  GlobalLogicTests
//
//  Created by Daniel Torres on 6/3/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import GlobalLogic

class RouterTests: XCTestCase {

    func test_Present_WhenSelectedItemConfigured_ShouldPresentADetailViewControllerWithTheSameItem(){
        //given a Router that has selected item configured and a navigationcontroller configured.
        let itemThatWillbeSelected = MockItem()
        let router = createRouterDetailItem(with: itemThatWillbeSelected)
        
        //when calling present from router.
        router.present()
        
        //router presents a detailViewVC on its navigationcontroller.
        let detailVc = router.navigationController?.viewControllers.last
        XCTAssertNotNil(detailVc)
        XCTAssertTrue(detailVc is DetailVcProtocol)
        //detailViewVC presented by the router has the selected Item.
        XCTAssertNotNil((detailVc as! DetailVcProtocol).selectedItem)
        XCTAssertEqual((detailVc as! DetailVcProtocol).selectedItem!.title, itemThatWillbeSelected.title)
    }
    
    func createRouterDetailItem(with item: ItemProtocol) -> DetailItemVcPresenter {
        let detailRouter = DetailItemRouter()
        detailRouter.selectedItem = item
        return detailRouter
    }
    
    class MockItem: ItemProtocol {
        var title: String = "a"
        var description: String = "b"
        var thumbnail: URL?
    }
}