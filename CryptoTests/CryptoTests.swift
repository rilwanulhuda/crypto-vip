//
//  CryptoTests.swift
//  CryptoTests
//
//  Created by Rilwanul Huda on 22/07/21.
//

@testable import Crypto

import Mockingbird
import XCTest

class CryptoTests: XCTestCase {
    var networkServiceMock: NetworkServiceMock!

    override func setUp() {
        super.setUp()
        networkServiceMock = mock(NetworkService.self)
    }

    override func tearDown() {
        networkServiceMock = nil
        super.tearDown()
    }
}
