//
//  CarRemoteRepository.swift
//  Carangas
//
//  Created by Vitor Ferraz Varela on 27/06/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation

protocol CarRepository {
    func save(car: Car, completion: @escaping (Result<Void,CarError>) -> Void)
    func update(car: Car, completion: @escaping(Result<Void,CarError>) -> Void)
    func delete(car: Car, completion: @escaping(Result<Void,CarError>) -> Void)
    func loadBrands(completion: @escaping(Result<[Brand],CarError>) -> Void)
    func loadCars(completion: @escaping(Result<[Car],CarError>) -> Void)
}
