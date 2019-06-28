//
//  CarMockRemoteRepository.swift
//  Carangas
//
//  Created by Vitor Ferraz Varela on 28/06/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Moya

struct CarMockRemoteRepository: CarRepository {
    private var engine: NetworkEngine<CarService> {
        return NetworkEngine<CarService>(provider: MoyaProvider<CarService>(stubClosure: MoyaProvider.immediatelyStub, plugins: []))
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