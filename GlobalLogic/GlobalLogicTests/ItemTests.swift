//
//  ItemTests.swift
//  GlobalLogicTests
//
//  Created by Daniel Torres on 5/29/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import GlobalLogic

class ItemTests: XCTestCase {
    var sut: Item!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = Item(title: "My Item", description: "My description")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit_ShouldSetTitleAndSetDescription(){
        XCTAssertNotNil(sut.title)
        XCTAssertNotNil(sut.description)
    }
    
    func testThumbnail_WhenSettingAvalidUrl_ShouldSetAnUrlThumbnail(){
        sut.thumbnail = URL(string: "https://www.linkedin.com/in/danstorre/")
        XCTAssertNotNil(sut.thumbnail)
    }
    
}
