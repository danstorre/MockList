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
    var sut: APIClient!
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
        let completionHandlerAfterDataIsReturned: APIClient.ItemlListHandler = { (_) in }
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
        let completionHandlerAfterDataIsReturned: APIClient.ItemlListHandler = { (_) in }
        sut.getItems(completion: completionHandlerAfterDataIsReturned)
        XCTAssertTrue(mocksession.dataTask.resumeCalled)
    }
    
    func testGetItems_WhenReturnedDataIsValid_CompletionHandlerShouldReturnArrayOfItems(){
        var items: [Item]?
        let completionHandlerAfterDataIsReturned = { (itemsFromBackend: [Item]?) in
            items = itemsFromBackend
        }
        sut.getItems(completion: completionHandlerAfterDataIsReturned)
        
        let data = [["title": "Item 1",
        "description": "Lorem ",
        "image": "https://picsum.photos/100/100?image=0"]]
        let responseData = try! JSONSerialization.data(withJSONObject: data,
                                                    options: [])
        //insert Data from Items.
        mocksession.completionHandler?(responseData, nil, nil)

        XCTAssertNotNil(items)
        XCTAssertEqual(items!.isEmpty, false)
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
}
