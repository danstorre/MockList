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
    
    func testPresentItemDetail_GivenAListOfItem_WhenSelectingOneOfThem_ShouldPresentTheDetailOfTheItem(){
        let navigationUseCase: MockNaviationUseCase = MockNaviationUseCase()
        let selectableItems = GivenASelectableArrayOfItemsThatGoToDetail(
                                                with: navigationUseCase)
        
        let givenFirstSelectableItem = selectableItems.first
        
        givenFirstSelectableItem?.select()
        
        XCTAssertTrue(navigationUseCase.gotoDetailWithItemGetsCalled)
    }
    
    func GivenASelectableArrayOfItemsThatGoToDetail(with navUseCase: NavigationDetailsUseCase) -> [ISelectable]{
        let items = [NavigatesToItemDetails(item: MockItem(),
                                           router: navUseCase)]
        return items
    }
    
    class MockNaviationUseCase: NavigationDetailsUseCase{
        var gotoDetailWithItemGetsCalled: Bool = false

        func gotoDetail(withItem: ItemProtocol) {
            gotoDetailWithItemGetsCalled = true
        }
    }
    
    class MockItem: ItemProtocol {
        var title: String = "a"
        var description: String = "b"
        var thumbnail: URL?
    }
}
