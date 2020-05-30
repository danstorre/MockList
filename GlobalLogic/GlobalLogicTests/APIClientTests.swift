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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetItems_MakesRequestToGetItemList(){
        let sut = APIClient()
        let mocksession = MockSession()
        sut.session = mocksession
        sut.getItems()
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
    
    class MockSession: DataTaskCreatorProtocol {
        typealias Handler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: Handler?
        var url: URL?
        
        func dataTask(with url: URL,
                      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.completionHandler = completionHandler
            self.url = url
            return URLSession.shared.dataTask(with: url)
        }
    }
}
