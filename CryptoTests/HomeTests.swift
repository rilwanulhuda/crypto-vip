//
//  HomeTests.swift
//  CryptoTests
//
//  Created by Rilwanul Huda on 22/07/21.
//

@testable import Crypto

import Mockingbird
import XCTest

class HomeTests: CryptoTests {
    var homeManagerMock: HomeManagerMock!
    var wsServiceMock: WSServiceMock!
    var interactor: HomeInteractor!
    var presenter: HomePresenter!

    override func setUp() {
        super.setUp()
        presenter = HomePresenter(view: nil)
        homeManagerMock = mock(HomeManager.self).initialize(networkService: networkServiceMock)
        wsServiceMock = mock(WSService.self).initialize()
        interactor = HomeInteractor(presenter: presenter, manager: homeManagerMock, wsService: wsServiceMock)
    }

    override func tearDown() {
        homeManagerMock = nil
        presenter = nil
        wsServiceMock = nil
        interactor = nil
        super.tearDown()
    }
    
    func testInitialSetup() {
        XCTAssertNotNil(interactor.presenter)
        XCTAssertNotNil(interactor.manager)
        XCTAssertNotNil(interactor.wsService)
    }
    
    func testGetTopListSuccessResponse() {
        let successResponse = mockResponse(of: TopListResponseModel.self, filename: .topListSuccessResponse)!
        
        _ = given(wsServiceMock.sendSubscription(action: any(), subscriptions: any()))

        given(homeManagerMock.getTopList(model: any(), completion: any())) ~> {
            _, result in
            result(.success(successResponse))
        }
        
        interactor.getTopList()
        
        verify(wsServiceMock.sendSubscription(action: any(), subscriptions: any())).wasCalled()
        verify(homeManagerMock.getTopList(model: any(), completion: any())).wasCalled()
        
        XCTAssertEqual(interactor.page, 1)
        XCTAssertEqual(interactor.coinsCount, 0)
        XCTAssertEqual(interactor.coinsCount, 0)
        XCTAssertEqual(presenter.topListCoins.count, successResponse.data?.count)
        XCTAssertFalse(presenter.topListCoins.isEmpty)
        
        for i in 0 ..< presenter.topListCoins.count {
            let sutCoin = presenter.topListCoins[i]
            let expectedCoin = successResponse.data![i]
            
            XCTAssertEqual(sutCoin.id, expectedCoin.coinInfo?.id)
            XCTAssertEqual(sutCoin.symbol, expectedCoin.coinInfo?.name)
            XCTAssertEqual(sutCoin.fullname, expectedCoin.coinInfo?.fullname)
            
            if let usd = expectedCoin.display?.usd {
                let change24HourUSD = usd.change24Hour ?? ""
                let change24Hour = change24HourUSD.replacingOccurrences(of: "$ ", with: "")
                let pctChange24Hour = usd.pctChange24Hour ?? ""
                
                if !change24Hour.contains("-") {
                    let expectedChanges = "+\(change24Hour)(+\(pctChange24Hour)%)"
                    XCTAssertEqual(sutCoin.changes, expectedChanges)
                } else {
                    let expectedChanges = "\(change24Hour)(\(pctChange24Hour)%)"
                    XCTAssertEqual(sutCoin.changes, expectedChanges)
                }
                
                XCTAssertEqual(sutCoin.price, expectedCoin.display?.usd?.price)
                
                let expectedOpenPrice = expectedCoin.display?.usd?.open24Hour?.replacingOccurrences(of: "$ ", with: "")
                XCTAssertEqual(sutCoin.openPrice, Double(expectedOpenPrice ?? "0"))
            } else {
                XCTAssertEqual(sutCoin.price, "n/a")
                XCTAssertEqual(sutCoin.changes, "n/a")
                XCTAssertNil(sutCoin.openPrice)
            }
        }
    }
    
    func testGetTopListSuccessResponseNoData() {
        let successResponse = mockResponse(of: TopListResponseModel.self, filename: .topListSuccessResponseNoData)!
        
        _ = given(wsServiceMock.sendSubscription(action: any(), subscriptions: any()))

        given(homeManagerMock.getTopList(model: any(), completion: any())) ~> {
            _, result in
            result(.success(successResponse))
        }
        
        interactor.getTopList()
        
        verify(wsServiceMock.sendSubscription(action: any(), subscriptions: any())).wasCalled()
        verify(homeManagerMock.getTopList(model: any(), completion: any())).wasCalled()
        
        XCTAssertEqual(interactor.page, 1)
        XCTAssertEqual(interactor.coinsCount, 0)
        XCTAssertEqual(interactor.coinsCount, 0)
        XCTAssertEqual(presenter.topListCoins.count, successResponse.data?.count)
        XCTAssertTrue(presenter.topListCoins.isEmpty)
        XCTAssertEqual(presenter.errorMsg, Messages.noCoinsFound)
    }
    
    func testGetTopListFailedResponse() {
        let expectedErrorMsg = Messages.generalError
        
        _ = given(wsServiceMock.sendSubscription(action: any(), subscriptions: any()))
        
        given(homeManagerMock.getTopList(model: any(), completion: any())) ~> {
            _, result in
            result(.failure(expectedErrorMsg))
        }
        
        interactor.getTopList()
        
        verify(wsServiceMock.sendSubscription(action: any(), subscriptions: any())).wasCalled()
        verify(homeManagerMock.getTopList(model: any(), completion: any())).wasCalled()
        
        XCTAssertEqual(interactor.page, 1)
        XCTAssertEqual(interactor.coinsCount, 0)
        XCTAssertEqual(interactor.coinsCount, 0)
        XCTAssertEqual(presenter.errorMsg, expectedErrorMsg)
        XCTAssertTrue(presenter.topListCoins.isEmpty)
    }
    
    func testLoadMoreTopList() {
        var expectedAllCoins: [TopListData] = []

        // Initial load page 1
        let mockSuccessResponse = mockResponse(of: TopListResponseModel.self, filename: .topListSuccessResponse)!

        _ = given(wsServiceMock.sendSubscription(action: any(), subscriptions: any()))
        
        given(homeManagerMock.getTopList(model: any(), completion: any())) ~> {
            _, result in
            result(.success(mockSuccessResponse))
        }
        
        interactor.getTopList()
        expectedAllCoins += mockSuccessResponse.data!

        verify(wsServiceMock.sendSubscription(action: any(), subscriptions: any())).wasCalled()
        verify(homeManagerMock.getTopList(model: any(), completion: any())).wasCalled()
        
        XCTAssertEqual(presenter.topListCoins.count, expectedAllCoins.count)
        XCTAssertFalse(presenter.topListCoins.isEmpty)
        
        // Start load more page 2
        let mockPageTwoSuccessResponse = mockResponse(of: TopListResponseModel.self, filename: .topListPageTwoSuccessResponse)!
        var expectedPage = interactor.page + 1
        
        given(homeManagerMock.getTopList(model: any(), completion: any())) ~> {
            _, result in
            result(.success(mockPageTwoSuccessResponse))
        }
        
        interactor.loadMoreTopList()
        expectedAllCoins += mockPageTwoSuccessResponse.data!
        
        XCTAssertEqual(interactor.page, expectedPage)
        XCTAssertEqual(presenter.topListCoins.count, expectedAllCoins.count)
        XCTAssertFalse(presenter.topListCoins.isEmpty)
        
        // Start load more page 3
        let mockPageThreeSuccessResponse = mockResponse(of: TopListResponseModel.self, filename: .topListPageThreeSuccessResponse)!
        expectedPage = interactor.page + 1

        given(homeManagerMock.getTopList(model: any(), completion: any())) ~> {
            _, result in
            result(.success(mockPageThreeSuccessResponse))
        }
        
        interactor.loadMoreTopList()
        expectedAllCoins += mockPageThreeSuccessResponse.data!
        
        XCTAssertEqual(interactor.page, expectedPage)
        XCTAssertEqual(presenter.topListCoins.count, expectedAllCoins.count)
        XCTAssertFalse(presenter.topListCoins.isEmpty)
        
        for i in 0 ..< presenter.topListCoins.count {
            let sutCoin = presenter.topListCoins[i]
            let expectedCoin = expectedAllCoins[i]
            
            XCTAssertEqual(sutCoin.id, expectedCoin.coinInfo?.id)
            XCTAssertEqual(sutCoin.symbol, expectedCoin.coinInfo?.name)
            XCTAssertEqual(sutCoin.fullname, expectedCoin.coinInfo?.fullname)
            
            if let usd = expectedCoin.display?.usd {
                let change24HourUSD = usd.change24Hour ?? ""
                let change24Hour = change24HourUSD.replacingOccurrences(of: "$ ", with: "")
                let pctChange24Hour = usd.pctChange24Hour ?? ""
                
                if !change24Hour.contains("-") {
                    let expectedChanges = "+\(change24Hour)(+\(pctChange24Hour)%)"
                    XCTAssertEqual(sutCoin.changes, expectedChanges)
                } else {
                    let expectedChanges = "\(change24Hour)(\(pctChange24Hour)%)"
                    XCTAssertEqual(sutCoin.changes, expectedChanges)
                }
                
                XCTAssertEqual(sutCoin.price, expectedCoin.display?.usd?.price)
            } else {
                XCTAssertEqual(sutCoin.price, "n/a")
                XCTAssertEqual(sutCoin.changes, "n/a")
            }
        }
    }
    
    func testLoadMoreTopListFailed() {
        let expectedErrorMsg = Messages.generalError
        let mockSuccessResponse = mockResponse(of: TopListResponseModel.self, filename: .topListSuccessResponse)
        
        // Initial load page 1
        given(homeManagerMock.getTopList(model: any(), completion: any())) ~> {
            _, result in
            result(.success(mockSuccessResponse!))
        }
        
        interactor.getTopList()
        
        verify(homeManagerMock.getTopList(model: any(), completion: any())).wasCalled()
        
        XCTAssertEqual(presenter.topListCoins.count, mockSuccessResponse?.data?.count)
        XCTAssertFalse(presenter.topListCoins.isEmpty)
        
        // Start load more page 2
        let currentTopListCount = presenter.topListCoins.count
        
        given(homeManagerMock.getTopList(model: any(), completion: any())) ~> {
            _, result in
            result(.failure(expectedErrorMsg))
        }
        
        interactor.loadMoreTopList()
        
        verify(homeManagerMock.getTopList(model: any(), completion: any())).wasCalled(2)
        
        XCTAssertEqual(interactor.page, 2)
        XCTAssertEqual(presenter.errorMsg, expectedErrorMsg)
        XCTAssertEqual(presenter.topListCoins.count, currentTopListCount)
    }
    
    func testCouldLoadMore() {
        // MARK: TestCouldLoadMore is TRUE

        interactor.coinsCount = 20
        interactor.currentCoinsCount = 10
        
        var couldLoadMore = interactor.couldLoadMore()
        
        XCTAssertEqual(couldLoadMore, true)
        
        // MARK: TestCouldLoadMore is FALSE

        interactor.coinsCount = 10
        interactor.currentCoinsCount = 10
        
        couldLoadMore = interactor.couldLoadMore()
        
        XCTAssertEqual(couldLoadMore, false)
    }
    
    func testSendSubscription() {
        _ = given(wsServiceMock.sendSubscription(action: any(), subscriptions: any()))
        
        interactor.sendSubscription(action: .subscribe)
        
        verify(wsServiceMock.sendSubscription(action: any(), subscriptions: any())).wasCalled()
    }
    
    func testDidUpdateConnectionStatus() {
        _ = given(wsServiceMock.sendSubscription(action: any(), subscriptions: any()))
        
        interactor.didUpdatedConnectionStatus(isConnected: true)
        
        verify(wsServiceMock.sendSubscription(action: any(), subscriptions: any())).wasCalled()
    }
    
    func testDidReceiveTickerResponse() {
        let mockSuccessResponse = mockResponse(of: TopListResponseModel.self, filename: .topListSuccessResponse)
        
        given(homeManagerMock.getTopList(model: any(), completion: any())) ~> {
            _, result in
            result(.success(mockSuccessResponse!))
        }
        
        interactor.getTopList()
        
        verify(homeManagerMock.getTopList(model: any(), completion: any())).wasCalled()
        
        XCTAssertEqual(presenter.topListCoins.count, mockSuccessResponse?.data?.count)
        XCTAssertFalse(presenter.topListCoins.isEmpty)
        
        let symbol = "TRX"
        let updatedPrice = 0.07798
        let tickerResponse = TickerResponseModel(symbol: symbol, price: updatedPrice)
        interactor.didReceiveTickerResponse(response: tickerResponse)
        
        for coin in presenter.topListCoins {
            if coin.symbol == symbol {
                XCTAssertEqual(coin.price, "$ \(updatedPrice)")
                break
            }
        }
    }
}
