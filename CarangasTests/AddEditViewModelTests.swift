//
//  AddEditViewModelTests.swift
//  CarangasTests
//
//  Created by Vitor Ferraz Varela on 29/06/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import XCTest
@testable import Carangas

class AddEditViewModelTests: XCTestCase {
    var sut: AddEditCarViewModel!
    override func setUp() {
        super.setUp()
        sut = AddEditCarViewModel( repository: CarRemoteRepository())
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLoadBrands_ExpectToLoadItems() {
        let expectation = XCTestExpectation(description: "Load brands from fipe api")
        
        sut.loadBrands {
            expectation.fulfill()
            XCTAssertGreaterThanOrEqual(self.sut.numberOfBrands, 0)
            XCTAssertEqual(self.sut.getBrand(at: 0)?.fipe_name, "AM Gen")
        }
        self.wait(for: [expectation], timeout: 10)

    }

}
