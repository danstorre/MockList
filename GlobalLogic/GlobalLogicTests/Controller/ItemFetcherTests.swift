//
//  ItemFetcherTests.swift
//  GlobalLogicTests
//
//  Created by Daniel Torres on 6/1/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import GlobalLogic

class ItemFetcherTests: XCTestCase {
    
    var sut: ItemFetcher!
    var mockService: MockService!
    var mockItemListHolder: MockItemListHolder!
    var mockDelegate: MockDelegate!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        mockItemListHolder = MockItemListHolder()
        mockService = MockService()
        mockDelegate = MockDelegate()
        sut = ItemFetcher(itemListHolder: mockItemListHolder, apiService: mockService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit_SetsItemListHolderAndItemService(){
        XCTAssertNotNil(sut.itemListHolder)
        XCTAssertNotNil(sut.apiService)
    }
    
    func testFetchItems_CallsService() {
        sut.fetchItems()
        XCTAssertTrue(mockService.getItemsGetsCalled)
    }
    
    func testFetchItems_whenThereIsNoError_updatesItemListHolder(){
        sut.fetchItems()
        mockItemListHolder.expectation = expectation(description: "listExpectation")
        let newItems = [MockItem(title: "b", description: "bdesc")]
        mockService.completion?(newItems, nil)
        wait(for: [mockItemListHolder.expectation!], timeout: 0.2)
        XCTAssertEqual(sut.itemListHolder.arrayOfItems[0].title, "b")
        XCTAssertEqual(sut.itemListHolder.arrayOfItems[0].description, "bdesc")
    }
    
    func testFetchItems_whenThereIsAnError_delegatesAnError(){
        sut.fetchItems()
        sut.delegate = mockDelegate
        mockDelegate.expectation = expectation(description: "man")
        mockService.completion?(nil, MockError.someError)
        wait(for: [mockDelegate.expectation!], timeout: 0.2)
        XCTAssertEqual(mockDelegate.error as! MockError, MockError.someError)
    }
    
    func testFetchItems_whenThereItemRetrieveIsEmpty_delegatesAnEmptyItemsFromServiceError(){
        sut.fetchItems()
        sut.delegate = mockDelegate
        mockDelegate.expectation = expectation(description: "man")
        mockService.completion?([MockItem](), nil)
        wait(for: [mockDelegate.expectation!], timeout: 0.2)
        XCTAssertEqual(mockDelegate.error as! ItemFetcherError,
                       ItemFetcherError.EmptyItemsFromService)
    }
    
    func testFetchItems_whenSuccessful_delegatesDidFinishMessage(){
        sut.fetchItems()
        sut.delegate = mockDelegate
        mockDelegate.expectation = expectation(description: "man")
        mockService.completion?([MockItem(title: "a", description: "a")], nil)
        wait(for: [mockDelegate.expectation!], timeout: 0.2)
        XCTAssertTrue(mockDelegate.finished)
    }
    
    func testFetchImage_CallsCompletionHandlerPassed(){
        var imageFromService: UIImage?
        let expectationImage: XCTestExpectation = expectation(description: "image")
        let completion : ((UIImage?) -> Void) = { image in
            imageFromService = image
            expectationImage.fulfill()
        }
        sut.fetchImage(from: URL(string: "sut")!, completion: completion)
        
        let expectedImage = UIImage(named: "icono")!
        let imageData = expectedImage.pngData()!
        mockService.completionData?(imageData, nil)
        wait(for: [expectationImage], timeout: 0.2)
        XCTAssertNotNil(imageFromService)
    }
    
    func testFetchImage_WhenThereIsAnError_returnsNil(){
        var imageFromService: UIImage?
        let completion : ((UIImage?) -> Void) = { image in
            imageFromService = image
        }
        sut.fetchImage(from: URL(string: "sut")!, completion: completion)
        mockService.completionData?(nil, MockError.someError)
        XCTAssertNil(imageFromService)
    }
    
    class MockItemListHolder: ItemListHolder{
        var expectation: XCTestExpectation?
        var arrayOfItems: [ItemProtocol] = [MockItem(title: "a", description: "a")] {
            didSet {
                expectation?.fulfill()
            }
        }
     }
    
    class MockService: APIProtocol{
        var getItemsGetsCalled = false
        var completion: ItemlListHandler?
        var completionData: DataHandler?
        
        func getItems(completion: @escaping (ItemlListHandler)) {
            getItemsGetsCalled = true
            self.completion = completion
        }
        
        func fetchData(from: URL, completion: @escaping(DataHandler)) {
            completionData = completion
        }
    }
    
    class MockDelegate: ItemFetcherDelegate{
        var error: Error?
        var finished: Bool = false
        var expectation: XCTestExpectation?
        func didFinish(with error: Error){
            self.error = error
            expectation?.fulfill()
        }
        func didFinish(){
            finished = true
            expectation?.fulfill()
        }
    }
    
    enum MockError: Error {
        case someError
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
