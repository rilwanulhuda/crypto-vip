//
//  NewsTests.swift
//  CryptoTests
//
//  Created by Rilwanul Huda on 22/07/21.
//

@testable import Crypto

import Mockingbird
import XCTest

class NewsTests: CryptoTests {
    var newsManagerMock: NewsManagerMock!
    var interactor: NewsInteractor!
    var presenter: NewsPresenter!
    
    override func setUp() {
        super.setUp()
        newsManagerMock = mock(NewsManager.self).initialize(networkService: networkServiceMock)
        presenter = NewsPresenter(view: nil)
        interactor = NewsInteractor(presenter: presenter, manager: newsManagerMock)
    }
    
    override func tearDown() {
        newsManagerMock = nil
        interactor = nil
        presenter = nil
        super.tearDown()
    }
    
    func testGetNewsSuccessResponse() {
        let mockSuccessResponse = mockResponse(of: NewsResponseModel.self, filename: .newsSuccessResponse)
        
        given(newsManagerMock.getNews(model: any(), completion: any())) ~> {
            _, result in
            result(.success(mockSuccessResponse!))
        }
        
        interactor.getNews()
        
        verify(newsManagerMock.getNews(model: any(), completion: any())).wasCalled()
        
        XCTAssertEqual(presenter.news.count, mockSuccessResponse?.data?.count)
        XCTAssertFalse(presenter.news.isEmpty)
        
        for i in 0 ..< presenter.news.count {
            let sutNews = presenter.news[i]
            let expectedNews = mockSuccessResponse!.data![i]
            
            if let title = expectedNews.title {
                XCTAssertEqual(sutNews.title, title)
            } else {
                XCTAssertEqual(sutNews.title, "n/a")
            }
            
            if let body = expectedNews.body {
                XCTAssertEqual(sutNews.body, body)
            } else {
                XCTAssertEqual(sutNews.body, "n/a")
            }
            
            if let source = expectedNews.sourceInfo?.name {
                XCTAssertEqual(sutNews.source, source)
            } else {
                XCTAssertEqual(sutNews.source, "n/a")
            }
        }
    }
    
    func testGetNewsSuccessResponseNoData() {
        let mockSuccessResponse = mockResponse(of: NewsResponseModel.self, filename: .newsSuccessResponseNoData)
        
        given(newsManagerMock.getNews(model: any(), completion: any())) ~> {
            _, result in
            result(.success(mockSuccessResponse!))
        }
        
        interactor.getNews()
        
        verify(newsManagerMock.getNews(model: any(), completion: any())).wasCalled()
        
        XCTAssertEqual(presenter.news.count, mockSuccessResponse?.data?.count)
        XCTAssertTrue(presenter.news.isEmpty)
        XCTAssertEqual(presenter.errorMsg, Messages.noNewsFound)
    }
    
    func testGetNewsFailed() {
        let expectedErrorMsg = Messages.generalError
        
        given(newsManagerMock.getNews(model: any(), completion: any())) ~> {
            _, result in
            result(.failure(expectedErrorMsg))
        }
        
        interactor.getNews()
        
        verify(newsManagerMock.getNews(model: any(), completion: any())).wasCalled()
        
        XCTAssertTrue(presenter.news.isEmpty)
        XCTAssertEqual(presenter.errorMsg, expectedErrorMsg)
    }
}
