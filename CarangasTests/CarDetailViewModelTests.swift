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
        sut = CarDetailViewModel(repository: CarMockRemoteRepository(), car: <#T##Car#>)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

}
