//
//  ListTableViewControllerTests.swift
//  GlobalLogicTests
//
//  Created by Daniel Torres on 5/31/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import GlobalLogic

class ListTableViewControllerTests: XCTestCase {
    var sut: ListTableViewController!
    var mockListFetcher: MockItemListFetcher!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = (storyboard
            .instantiateViewController(withIdentifier: "ListTableViewController") as! ListTableViewController)
        mockListFetcher = MockItemListFetcher()
        sut.fetcher = mockListFetcher
        sut.dataSource = mockListFetcher
        _ = sut.view
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHasFetcher(){
        XCTAssertNotNil(sut.fetcher)
    }
    
    func testViewDidLoad_TableViewIsNotNil(){
        _ = sut.view
        XCTAssertNotNil(sut.tableView)
    }
    
    func testViewDidLoad_CallsItemListFetcherController(){
        XCTAssertTrue(mockListFetcher.fetchGetsCalled)
    }
    
    func testNumberOfSections_ReturnsOne(){
        XCTAssertEqual(sut.numberOfSections(in: sut.tableView),
                       1,
                       "number of sections is 1.")
    }
    
    func testViewDidLoad_CallsGetNumberOfRowsFromFetcher(){
        XCTAssertTrue(mockListFetcher.numberOfRowsGetsCalled)
    }
    
    func testCellForRow_ReturnsCell() {
        sut.tableView.reloadData()
        let cell = sut.tableView
            .cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is ItemCell)
    }
    
    func testCellForRow_DequeuesCell() {
        let mockTableView = MockTableView.mockTableViewWithDataSource(sut)

        mockTableView.reloadData()
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(mockTableView.cellGotDequeued)
    }
    
    func testGetTitleAndDescription_GetsCalledInCellForRow() {
        let mockTableView = MockTableView.mockTableViewWithDataSource(sut)
        mockTableView.reloadData()
        let cell = mockTableView.cellForRow(at:
            IndexPath(row: 0, section: 0)) as! MockItemCell
        XCTAssertEqual(cell.mocktitle, "my")
        XCTAssertEqual(cell.mockdescription, "desc")
    }
    
    class MockItemListFetcher: ItemListFetcher, ItemLisDataSource {
        var fetchGetsCalled = false
        var numberOfRowsGetsCalled = false
        var numberOfRowsInSection = 0
        var getItemAndDescriptionTupleGetsCalled = true
        
        var arrayOfItems: [Item] = [Item(title: "my", description: "desc")]
        func fetchItems() {
            fetchGetsCalled = true
        }
        
        func getNumberOfRows(section: Int) -> Int {
            numberOfRowsGetsCalled = true
            return arrayOfItems.count
        }
        
        func getItemAndDescriptionTuple(at index: Int) -> (String, String) {
            getItemAndDescriptionTupleGetsCalled = true
            guard !arrayOfItems.isEmpty else{
                return ("","")
            }
            let item = arrayOfItems[index]
            return (item.title, item.description)
        }
    }
    
    class MockTableView : UITableView {
        var cellGotDequeued = false
        
        override func dequeueReusableCell(withIdentifier identifier: String,
                                          for indexPath: IndexPath) -> UITableViewCell {
            cellGotDequeued = true
            return super.dequeueReusableCell(withIdentifier: identifier,
                                             for: indexPath)
        }
        
        static func mockTableViewWithDataSource(_
            dataSource: UITableViewDataSource) -> MockTableView {
            let mockTableView = MockTableView(
                frame: CGRect(x: 0, y: 0,
                              width: 320, height: 1080),
                style: .plain)
            mockTableView.dataSource = dataSource
            mockTableView.register(MockItemCell.self,
                                   forCellReuseIdentifier: "ItemCell")
            return mockTableView
        }
    }
    
    class MockItemCell : ItemCell {
        var mocktitle: String?
        var mockdescription: String?
        
        override func configuresCellWith(title: String, and description: String) {
            self.mocktitle = title
            self.mockdescription = description
        }
    }
}
