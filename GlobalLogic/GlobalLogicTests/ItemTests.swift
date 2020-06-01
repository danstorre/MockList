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
    
    func testInit2_ShouldSetTitleAndSetDescriptionAndThumnail(){
        sut = Item(title: "Title",
                   description: "desc",
                   thumbnail: URL(fileURLWithPath: "https://www.google.com"))
        XCTAssertNotNil(sut.title)
        XCTAssertNotNil(sut.description)
        XCTAssertNotNil(sut.thumbnail)
    }
    
    func testThumbnail_WhenSettingAvalidUrl_ShouldSetAnUrlThumbnail(){
        sut.thumbnail = URL(string: "https://www.linkedin.com/in/danstorre/")
        XCTAssertNotNil(sut.thumbnail)
    }
    
    func testInit_whenDecodingItemWithJsonDecoder_ShouldSetTitleAndSetDescription(){
        let data = ["title": "Item 1",
        "description": "Lorem "]
        let item = try! returnItemDataFromDict(data)
        
        XCTAssertEqual(item.title, "Item 1")
        XCTAssertEqual(item.description, "Lorem ")
        XCTAssertNil(item.thumbnail)
    }
    
    func testInit_whenPassingAJsonWithThumbnail_ShouldSetAThumnail(){
        let data = ["title": "Item 1",
        "description": "Lorem ",
        "image": "https://picsum.photos/100/100?image=0"]
        let item = try! returnItemDataFromDict(data)
        
        XCTAssertEqual(item.title, "Item 1")
        XCTAssertEqual(item.description, "Lorem ")
        XCTAssertEqual(item.thumbnail, URL(string: "https://picsum.photos/100/100?image=0"))
    }
    
    func testInit_WhenImageUrlDataIsCorrupted_ThrowsErrorUrlIsNotValid(){
        let data = ["title": "Item 1",
        "description": "Lorem ",
        "image": "httpspicsum.photos/100/100mage=0"]
        
        XCTAssertThrowsError(try returnItemDataFromDict(data), "", { (error) in
            XCTAssertTrue(error is ItemError)
            XCTAssertEqual(error as! ItemError, ItemError.ErrorImageUrlIsNotValid)
        })
    }
    
    func returnItemDataFromDict(_ dict: [String: String]) throws -> Item {
        let jsonEncoder = JSONEncoder()
        let dataJson = try! jsonEncoder.encode(dict)
        let JsonDecoder = JSONDecoder()
        return try JsonDecoder.decode(Item.self, from: dataJson)
    }
    
}
