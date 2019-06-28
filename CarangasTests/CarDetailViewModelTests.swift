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
        super.tearDown()
        sut = nil
    }
    
    func testViewModelCurrencyFormatter_ExpectToFormatValue() {
        XCTAssertEqual(sut.price, "R$ 9.000.000,00")
    }

}
