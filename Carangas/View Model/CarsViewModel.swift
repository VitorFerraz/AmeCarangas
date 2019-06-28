//
//  CarsViewModel.swift
//  Carangas
//
//  Created by Vitor Ferraz Varela on 28/06/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation
class CarsViewModel {
    let repository: CarRepository
    var stateChange: (()-> Void)?
    private var cars: [Car] = [] {
        didSet {
            currentState = cars.isEmpty ? .noCars : .loaded
        }
    }
    var currentState: State = .loading {
        didSet {
            stateChange?()
        }
    }
    
    var numberOfCars: Int {
        return cars.count
    }
    enum State: String {
        case loading = "Carregando carros..."
        case noCars = "Não existem carros cadastrados."
        case loaded = ""
    }
    
    init(repository: CarRepository = CarRemoteRepository()) {
        self.repository = repository
    }
    
    func removeCar(at indexPath: IndexPath) {
        if cars.indices.contains(indexPath.row) {
            self.cars.remove(at: indexPath.row)
        }
    }
    
    func car(for indexPath: IndexPath) -> Car? {
//        if cars.indices.contains(indexPath.row) {
//            return cars[indexPath.row]
//        } else {
//            return nil
//        }
        return cars.indices.contains(indexPath.row) ? cars[indexPath.row] : nil
    }
    
    func loadCars(completion: @escaping() -> Void) {
        currentState = .loading
        repository.loadCars { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let cars):
                self.cars = cars
            }
            completion()
        }
    }
    
    func delete(car: Car, at indexPath: IndexPath, completion: @escaping() -> Void) {
        repository.delete(car: car) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success:
                self.removeCar(at: indexPath)
            }
            completion()

        }
    }
}
