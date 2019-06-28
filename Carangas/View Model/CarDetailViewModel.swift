//
//  CarDetailViewModel.swift
//  Carangas
//
//  Created by Vitor Ferraz Varela on 28/06/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import UIKit
final class CarDetailViewModel {
    private (set) var car: Car
    private var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "R$ "
        formatter.locale = Locale(identifier: "pt-BR")
        formatter.alwaysShowsDecimalSeparator = true
        return formatter
    }()
    init(car: Car) {
        self.car = car
    }
    
    var name: String {
        return car.name
    }
    var brand: String {
        return car.brand
    }
    
    var price: String {
        return formatter.string(for: car.price) ?? "R$ ..."
    }
    
    var gas: String {
        return car.gas
    }
    
    var nameSearch: String {
        return (car.name + "+" + car.brand).replacingOccurrences(of: " ", with: "+")
    }
}
