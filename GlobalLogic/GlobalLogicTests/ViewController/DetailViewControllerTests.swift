//
//  DetailViewControllerTests.swift
//  GlobalLogicTests
//
//  Created by Daniel Torres on 6/3/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import XCTest
@testable import GlobalLogic

protocol MockFetcherProtocol: ImageFetcher {
    var completion: ImageHandler? {get set}
    var callsFetchData: Bool {get set}
}

class DetailViewControllerTests: XCTestCase {
    
    func testViewDidLoad_NecessaryPropertiesAreNotNil(){
        //given an item.
        let item = MockItem()
        
        //when presenting the detail vc with that item.
        let vc = createADetailVC(with: item)
        _ = vc.view
        
        //then asserts its titlelabel, description are not nil and properly configured.
        XCTAssertEqual(item.title, vc.titleLabel.text)
        XCTAssertEqual(item.description, vc.descriptionLabel.text)
    }
    
    func testViewDidLoad_WhenImageUrlIsPresented_ShouldCallAnImageFetcher(){
        //given an item with url.
        let itemWithUrl = createItemWithUrl()
        
        //when presenting the detail vc with that item.
        let fetcher = createFetcher()
        let vc = createADetailVCWithImageFetcher(with: itemWithUrl, and: fetcher)
        _ = vc.view
        //and fetcher has image data.
        let imageData = UIImage(named: "icono")!
        fetcher.completion?(imageData)
        
        //then assert that vc calls its imageFetcher.
        XCTAssertTrue(fetcher.callsFetchData)
        //and assert that imageView from vc has set its image.
        XCTAssertNotNil(vc.imageView.image)
    }
    
    func testViewDidLoad_WhenImageUrlIsPresented_butServiceReturnsNoValidImageData_ShouldHideImageview(){
        //given an item with url.
        let itemWithUrl = createItemWithUrl()
        
        //when presenting the detail vc with that item.
        let fetcher = createFetcher()
        let vc = createADetailVCWithImageFetcher(with: itemWithUrl, and: fetcher)
        _ = vc.view
        //and fetcher has image data.
        fetcher.completion?(nil)
        
        //then assert that vc calls its imageFetcher.
        XCTAssertTrue(fetcher.callsFetchData)
        //and assert that imageView is hidden
        XCTAssertTrue(vc.imageView.isHidden)
    }
    
    func testViewDidLoad_WhenImageUrlIsNotPresented_ShouldHideImageview(){
        //given an item with url.
        let itemWithUrl = createItemWithoutUrl()
        
        //when presenting the detail vc with that item.
        let vc = createADetailVC(with: itemWithUrl)
        _ = vc.view
        
        //and assert that imageView is hidden
        XCTAssertTrue(vc.imageView.isHidden)
    }
    
    enum MockError: Error {
        case someError
    }
    
    func createADetailVC(with item: ItemProtocol) -> DetailVcProtocol{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = (storyboard
            .instantiateViewController(withIdentifier: "DetailViewController") as! DetailVcProtocol)
        vc.selectedItem = item
        
        return vc
    }
    
    func createADetailVCWithImageFetcher(with item: ItemProtocol,
                                         and fetcher: ImageFetcher) -> DetailVcProtocol{
        let vc = createADetailVC(with: item)
        vc.fetcher = fetcher
        
        return vc
    }
    
    func createFetcher() -> MockFetcherProtocol {
        return MockFetcher()
    }
    
    func createItemWithUrl() -> ItemProtocol{
        let mockitem = MockItem()
        mockitem.thumbnail = URL(string: "www.google.com")
        return mockitem
    }
    
    func createItemWithoutUrl() -> ItemProtocol{
        let mockitem = MockItem()
        return mockitem
    }
    
    class MockFetcher: MockFetcherProtocol {
        var callsFetchData: Bool = false
        var completion: ImageHandler?
        func fetchImage(from url: URL, completion: @escaping (ImageHandler)) {
            callsFetchData = true
            self.completion = completion
        }
    }
    
    class MockItem: ItemProtocol {
        var title: String = "title"
        var description: String = "descp"
        var thumbnail: URL?
    }
}
