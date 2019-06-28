//
//  CarRemoteRepository.swift
//  Carangas
//
//  Created by Vitor Ferraz Varela on 27/06/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Moya

protocol CarRepository {
    func save(car: Car, completion: @escaping (Result<Void,CarError>) -> Void)
    func update(car: Car, completion: @escaping(Result<Void,CarError>) -> Void)
    func delete(car: Car, completion: @escaping(Result<Void,CarError>) -> Void)
    func loadBrands(completion: @escaping(Result<[Brand],CarError>) -> Void)
    func loadCars(completion: @escaping(Result<[Car],CarError>) -> Void)
}

struct CarRemoteRepository: CarRepository {
    private var engine: NetworkEngine<CarService> {
        return NetworkEngine<CarService>(provider: MoyaProvider<CarService>())
    }
    
    func save(car: Car, completion: @escaping (Result<Void, CarError>) -> Void) {
        engine.requestVoid(target: .save(car: car), completion: completion)
    }
    
    func update(car: Car, completion: @escaping (Result<Void, CarError>) -> Void) {
        engine.requestVoid(target: .update(car: car), completion: completion)
    }
    
    func delete(car: Car, completion: @escaping (Result<Void, CarError>) -> Void) {
        engine.requestVoid(target: .delete(car: car), completion: completion)
    }
    
    func loadBrands(completion: @escaping (Result<[Brand], CarError>) -> Void) {
        engine.request(target: .loadBrands, completion: completion)
    }
    
    func loadCars(completion: @escaping (Result<[Car], CarError>) -> Void) {
        engine.request(target: .loadCars, completion: completion)
    }
}