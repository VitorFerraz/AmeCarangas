//
//  CarDetailViewModelTests.swift
//  CarangasTests
//
//  Created by Vitor Ferraz Varela on 28/06/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import XCTest
@testable import Carangas

class CarDetailViewModelTests: XCTestCase {
    var sut: CarDetailViewModel!
    override func setUp() {
        super.setUp()
        let car: Car = Car.fromJSON("CarMock")!
        sut = CarDetailViewModel(car: car)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFormatter_ExpectToFormatValueToReal() {
        XCTAssertEqual(sut.price, "R$ 9.000.000,00")
    }

}
