//
//  CarsViewModelTests.swift
//  CarangasTests
//
//  Created by Vitor Ferraz Varela on 28/06/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//
import XCTest
@testable import Carangas

class CarsViewModelTests: XCTestCase {

    var sut: CarsViewModel!
    override func setUp() {
        super.setUp()
        sut = CarsViewModel(repository: CarMockRemoteRepository())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoadCars_ExpectToGetNotEmptyList() {
        sut.loadCars {
            XCTAssertGreaterThanOrEqual(self.sut.numberOfCars, 1)
        }
    }

}
