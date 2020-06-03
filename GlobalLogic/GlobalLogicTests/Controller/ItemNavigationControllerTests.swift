//
//  RouterTests.swift
//  GlobalLogicTests
//
//  Created by Daniel Torres on 6/3/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import GlobalLogic


protocol MockRouterProtocol: RouterDetailItemProtocol {
    var presentGetsCalled: Bool {get set}
}

class ItemNavigationControllerTests: XCTestCase {
    
    func test_GoToDetailItem_WhenSelectingAnItemFromAnObjectWithListOfItems_RouterPresentGetsCalled(){
        // given an object with a selectable list of items that has a router
        let itemExpectedToSelect = createAMockItemWithoutAnUrl()
        let objectWithItems = givenAnObjectWithAListOfItems([itemExpectedToSelect])
        // when selecting an item
        objectWithItems.selectsItem(at: 0)
        // objectWithItems delegates configuration and presentation to its router passing in the item selected
        XCTAssertEqual((objectWithItems.router as! MockRouterProtocol).presentGetsCalled, true)
        XCTAssertNotNil(objectWithItems.router.selectedItem)
        XCTAssertEqual(objectWithItems.router.selectedItem!.title, itemExpectedToSelect.title)
        XCTAssertNil(objectWithItems.router.selectedItem!.thumbnail)
        XCTAssertEqual(objectWithItems.router.selectedItem!.description, itemExpectedToSelect.description)
    }
    
    func givenAnObjectWithAListOfItems(_ items:[ItemProtocol]) -> ItemSelectableNavigatable {
        return ItemNavigationController(router: MockRouter(),
                                        itemListHolder: MockItemListHolder(array: items))
    }
    
    func createAMockItemWithoutAnUrl() -> ItemProtocol {
        return MockItem()
    }
}

extension ItemNavigationControllerTests{
    struct MockItem: ItemProtocol{
        var title: String = "a"
        var description: String = "a"
        var thumbnail: URL?
    }
    
    class MockRouter: MockRouterProtocol{
        var selectedItem: ItemProtocol?
        var presentGetsCalled = false
        
        func present() {
            presentGetsCalled = true
        }
    }
    
    class MockItemListHolder : ItemListHolder {
        var arrayOfItems: [ItemProtocol] = [MockItem()]
        init(array: [ItemProtocol]) {
            self.arrayOfItems = array
        }
    }
}
