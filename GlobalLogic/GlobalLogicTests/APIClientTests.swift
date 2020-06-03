//
//  APIClientTests.swift
//  GlobalLogicTests
//
//  Created by Daniel Torres on 5/29/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import GlobalLogic

class APIClientTests: XCTestCase {
    var sut: APIClient<MockItem>!
    var mocksession: MockSession!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = APIClient()
        mocksession = MockSession()
        sut.session = mocksession
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetItems_MakesRequestToGetItemList(){
        let completionHandlerAfterDataIsReturned: APIClient.ItemlListHandler = { (_, _) in }
        sut.getItems(completion: completionHandlerAfterDataIsReturned)
        //assert completion handler is not nil
        XCTAssertNotNil(mocksession.completionHandler)
        XCTAssertNotNil(mocksession.url)
        
        //assert url the one expected.
        let domainExpected = "private-f0eea-mobilegllatam.apiary-mock.com"
        let schemeExpected = "http"
        let pathExpected = "/list"
        let urlFromTask = mocksession.url!
        
        let components = URLComponents(url: urlFromTask,
                                       resolvingAgainstBaseURL: false)!
        XCTAssertEqual(components.scheme, schemeExpected)
        XCTAssertEqual(components.host, domainExpected)
        XCTAssertEqual(components.path, pathExpected)
    }
    
    func testGetItems_CallsresumeDataTask(){
        let completionHandlerAfterDataIsReturned: APIClient.ItemlListHandler = { (_, _) in }
        sut.getItems(completion: completionHandlerAfterDataIsReturned)
        XCTAssertTrue(mocksession.dataTask.resumeCalled)
    }
    
    func testGetItems_WhenReturnedDataIsValid_CompletionHandlerShouldReturnArrayOfItems(){
        var items: [MockItem]?
        let completionHandlerAfterDataIsReturned: APIClient.ItemlListHandler = { (itemsFromBackend: [ItemProtocol]?, _) in
            items = itemsFromBackend as? [APIClientTests.MockItem]
        }
        sut.getItems(completion: completionHandlerAfterDataIsReturned)
        
        let mockParser = MockParser()
        sut.parser = mockParser
        
        //insert Data from Items.
        mocksession.completionHandler?(Data(), nil, nil)

        XCTAssertNotNil(items)
        XCTAssertEqual(items!.isEmpty, false)
    }
    
    func testGetItems_ThrowsADataInvalidError(){
        var theError: Error?
        let completionHandlerAfterDataIsReturned: APIClient.ItemlListHandler = { (_: [ItemProtocol]?, error: Error?) in
            theError = error
        }
        sut.getItems(completion: completionHandlerAfterDataIsReturned)
        let mockparser = MockParser()
        mockparser.throwsError = WebserviceError.DataEmptyError
        sut.parser = mockparser
        
        let responseData = Data()
        //insert Data from Items.
        mocksession.completionHandler?(responseData, nil, nil)

        XCTAssertNotNil(theError)
    }
    
    func testGetItems_ThrowsAnInvalidImageURLError(){
        var theError: Error?
        let completionHandlerAfterDataIsReturned: APIClient.ItemlListHandler = { (_: [ItemProtocol]?, error: Error?) in
            theError = error
        }
        sut.getItems(completion: completionHandlerAfterDataIsReturned)
        let mockparser = MockParser()
        mockparser.throwsError = WebserviceError.InvalidImageURLError
        sut.parser = mockparser
        
        //insert Data from Items.
        mocksession.completionHandler?(Data(), nil, nil)

        XCTAssertEqual(theError as! WebserviceError, WebserviceError.InvalidImageURLError)
    }
    
    func testGetItems_WhenDataHasNoImage_ReturnsItemsWithoutImage(){
        var items: [MockItem]?
        let completionHandlerAfterDataIsReturned: APIClient.ItemlListHandler = { (itemsFromBackend: [ItemProtocol]?, _) in
            items = itemsFromBackend as? [APIClientTests.MockItem]
        }
        sut.getItems(completion: completionHandlerAfterDataIsReturned)
        let mockParser = MockParser()
        let itemExpected = MockItem()
        itemExpected.title = "Item 2"
        itemExpected.description = "Lorem 2"
        itemExpected.thumbnail = nil
        mockParser.itemsToReturn = [MockItem(),itemExpected]
        sut.parser = mockParser
        
        //insert Data from Items.
        mocksession.completionHandler?(Data(), nil, nil)

        XCTAssertNotNil(items)
        XCTAssertEqual(items!.isEmpty, false)
        XCTAssertEqual(items![1].title, "Item 2")
        XCTAssertEqual(items![1].description, "Lorem 2")
        XCTAssertNil(items![1].thumbnail)
    }
    
    func testGetItems_ThrowsADataEmptyError(){
        var theError: Error?
        let completionHandlerAfterDataIsReturned: APIClient.ItemlListHandler = { (_: [ItemProtocol]?, error: Error?) in
            theError = error
        }
        sut.getItems(completion: completionHandlerAfterDataIsReturned)
        //insert Data from Items.
        mocksession.completionHandler?(nil, nil, nil)

        XCTAssertEqual(theError as! WebserviceError, WebserviceError.DataEmptyError)
    }
    
    func testGetItems_WhenResponseHasError_ThrowsAnError(){
        var theError: Error?
        let completionHandlerAfterDataIsReturned: APIClient.ItemlListHandler = { (_: [ItemProtocol]?, error: Error?) in
            theError = error
        }
        sut.getItems(completion: completionHandlerAfterDataIsReturned)
        //insert Data from Items.
        let anyerror = NSError(domain: "myerror", code: 112, userInfo: nil)
        mocksession.completionHandler?(nil, nil, anyerror as Error)
        XCTAssertNotNil(theError)
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
        
        init(){
        }
        
        required init(from decoder: Decoder) throws {
            callsDecoder = true
        }
    }
    
    class MockSession: DataTaskCreatorProtocol {
        typealias Handler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: Handler?
        var url: URL?
        var dataTask = MockSessionTask()
        
        func dataTask(with url: URL,
                      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.completionHandler = completionHandler
            self.url = url
            return dataTask
        }
    }
    
    class MockSessionTask: URLSessionDataTask {
        var resumeCalled: Bool = false

        override func resume() {
            resumeCalled = true
        }
    }
    
    class MockParser: JsonParser<[MockItem]> {
        var throwsError: Error?
        var itemsToReturn: [MockItem] = [MockItem()]
        
        override func decode(data: Data) throws -> [APIClientTests.MockItem] {
            if let throwsError = throwsError {
                throw throwsError
            }
            
            return itemsToReturn
        }
    }
}
