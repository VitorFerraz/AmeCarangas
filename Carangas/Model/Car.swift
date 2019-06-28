//
//  Car.swift
//  Carangas
//
//  Created by Eric Brito on 14/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import Foundation

class Car: Codable {
    var brand: String = ""
    var name: String = ""
    var price: Double = 0.0
    var gasType: Int = 0
    var _id: String?
    
    var gas: String {
        switch gasType {
            case 0:
                return "Flex"
            case 1:
                return "Álcool"
            default:
                return "Gasolina"
        }
    }
}

struct Brand: Codable {
    let fipe_name: String
}









