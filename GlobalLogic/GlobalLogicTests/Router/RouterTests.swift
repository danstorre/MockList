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

//    DetailsUseCase
//    goToDetail(withItem: ItemProtocol)
    var navigationUseCase: MockNaviationUseCase!

    func testPresentItemDetail_WhenGivenAListOfItemAndSelectingOneOfThem_ShouldPresentTheDetailOfTheItem(){
        
        //given a list of items that user can select.
        //and the first item of the list.
        //when selecting the first item of the list
        //then the user sees a screen with the details of the item.
        
        //given a list of items that user can select.
        let selectableItems = GivenASelectableArrayOfItems()
        //and given the first item of the list.
        let givenFirstSelectableItem = selectableItems.first
        
        //when selecting the first item of the list
        givenFirstSelectableItem?.select()
        
        //then the user sees a screen with the details of the item.
        //assert delegates a message to present a detail screen.
        //in this case goToDetail(withItem: ItemProtocol)
        XCTAssertNotNil(givenFirstSelectableItem)
        XCTAssertTrue(navigationUseCase.gotoDetailWithItemGetsCalled)
    }
    
    func GivenASelectableArrayOfItems() -> [ISelectable]{
        navigationUseCase = MockNaviationUseCase()
        let items = [NavigatesToItemDetails(item: MockItem(),
                                           router: navigationUseCase)]
        return items
    }
    
    class MockNaviationUseCase: NavigationDetailsUseCase{
        var gotoDetailWithItemGetsCalled: Bool = false

        func gotoDetail(withItem: ItemProtocol) {
            gotoDetailWithItemGetsCalled = true
        }
    }
    
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
