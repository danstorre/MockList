//
//  ItemDataSourceTests.swift
//  GlobalLogicTests
//
//  Created by Daniel Torres on 6/1/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import GlobalLogic

class ItemDataSourceTests: XCTestCase {
    var sut: ItemDataSource!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        let itemListHolder = MockitemListHolder()
        sut = ItemDataSource(presenting: itemListHolder)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit_shouldSetAnItemPresentable(){
        XCTAssertNotNil(sut.itemListHolder)
    }
    
    func testGetThumnailURL_WhenItemPresentableHasThumnailURL_shouldReturnURL(){
        XCTAssertNotNil(sut.getThumnailURL(at: 0))
    }
    
    func testGetThumnailURL_WhenItemPresentableHasnoThumnailURL_shouldReturnNil(){
        sut.itemListHolder.arrayOfItems[0].thumbnail = nil
        XCTAssertNil(sut.getThumnailURL(at: 0))
    }
    
    func testGetThumnailURL_WhenItemPresentableHasNoItems_ShouldReturnNil(){
        sut.itemListHolder.arrayOfItems = [MockItem]()
        XCTAssertNil(sut.getThumnailURL(at: 0))
    }
    
    func testgetItemAndDescriptionTuple_WhenGivenAtIndexOutOfRange_ShouldReturnNil(){
        XCTAssertNil(sut.getThumnailURL(at: 1))
    }
    
    func testGetNumberOfRows_WhenItemPresentableHasNoItems_ShouldReturnZero(){
        sut.itemListHolder.arrayOfItems = [MockItem]()
        XCTAssertEqual(sut.getNumberOfRows(section: 0), 0)
    }
    
    func testGetNumberOfRows_WhenItemPresentableHasItems_ShouldReturnCount(){
        XCTAssertEqual(sut.getNumberOfRows(section: 0), 1)
    }
    
    func testgetItemAndDescriptionTuple_WhenItemPresentableHasItems_ShouldReturnItsTitleAndDescriptionFromItemAtIndex(){
        XCTAssertEqual(sut.getItemAndDescriptionTuple(at: 0).0, "a")
        XCTAssertEqual(sut.getItemAndDescriptionTuple(at: 0).1, "a")
    }
    
    func testgetItemAndDescriptionTuple_WhenItemPresentableHasNoItems_ShouldReturnEmptyStrings(){
        sut.itemListHolder.arrayOfItems = [MockItem]()
        XCTAssertEqual(sut.getItemAndDescriptionTuple(at: 0).0, "")
        XCTAssertEqual(sut.getItemAndDescriptionTuple(at: 0).1, "")
    }
    
    func testgetItemAndDescriptionTuple_WhenGivenAtIndexOutOfRange_ShouldReturnEmptyStrings(){
        XCTAssertEqual(sut.getItemAndDescriptionTuple(at: 1).0, "")
        XCTAssertEqual(sut.getItemAndDescriptionTuple(at: 1).1, "")
    }
    
    class MockitemListHolder: ItemListHolder {
        var arrayOfItems: [ItemProtocol] = [MockItem(title: "a",
                                         description: "a",
                                         thumbnail: URL(string: "abc")!)]
    }
    
    
    class MockItem: ItemProtocol{
        var title: String = ""
        var description: String = ""
        var thumbnail: URL?
        
        var callsDecoder = false
        
        enum CodingKeys: String, CodingKey {
            case title
            case description
            case thumbnail = "image"
        }
        
        init(title: String, description: String) {
            self.title = title
            self.description = description
        }
        
        init(title: String, description: String, thumbnail: URL) {
            self.title = title
            self.description = description
            self.thumbnail = thumbnail
        }
        
        required init(from decoder: Decoder) throws {
            callsDecoder = true
        }
    }
}
