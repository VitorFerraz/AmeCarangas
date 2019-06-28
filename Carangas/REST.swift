//
//  REST.swift
//  Carangas
//
//  Created by Eric Brito on 14/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import Foundation
import UIKit

enum CarError: Error {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

enum RESTOperation {
    case update
    case delete
    case save
}

class REST {
    
    private static let basePath = "https://carangas.herokuapp.com/cars"
    private static let FIPEPath = "https://fipeapi.appspot.com/api/1/carros/marcas.json"
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 45.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    private static let session = URLSession(configuration: configuration)
    
    class func loadCars(completion: @escaping (Result<[Car], CarError>) -> Void) {
        guard let url = URL(string: basePath) else {
            completion(.failure(CarError.url))
            return
        }
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion(.failure(CarError.taskError(error: error)))
            } else {
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(CarError.noResponse))
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {
                        completion(.failure(CarError.noData))
                        return
                    }
                    do {
                        let cars = try JSONDecoder().decode([Car].self, from: data)
                        completion(.success(cars))
                        
                    } catch {
                        completion(.failure(CarError.invalidJSON))
                        
                    }
                    
                } else {
                    completion(.failure(CarError.responseStatusCode(code: response.statusCode)))
                }
            }
            }.resume()
    }
    class func save(car: Car, completion: @escaping (Result<Void, CarError>)-> Void) {
        applyOperation(car: car, operation: .save, completion: completion)
        
    }
    class func delete(car: Car, completion: @escaping (Result<Void, CarError>)-> Void) {
        applyOperation(car: car, operation: .delete, completion: completion)
        
    }
    class func update(car: Car, completion: @escaping (Result<Void, CarError>)-> Void) {
        applyOperation(car: car, operation: .update, completion: completion)
    }
    
    class func loadBrands(completion: @escaping (Result<[Brand],CarError>) -> Void) {
        guard let url = URL(string: FIPEPath) else {
            completion(.failure(CarError.url))
            return
        }
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                return completion(.failure(CarError.taskError(error: error)))
            } else {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
                    return completion(.failure(CarError.noData))
                    
                }
                if let brands = try? JSONDecoder().decode([Brand].self, from: data) {
                    return completion(.success(brands))
                } else {
                    return completion(.failure(CarError.invalidJSON))
                }
            }
            
            }.resume()
    }
    
    private class func applyOperation(car: Car, operation: RESTOperation, completion: @escaping (Result<Void,CarError>) -> Void) {
        let urlString = basePath + "/" + (car._id ?? "")
        var httpMethod = "GET"
        switch operation {
        case .save:
            httpMethod = "POST"
        case .delete:
            httpMethod = "DELETE"
        case .update:
            httpMethod = "PUT"
        }
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(CarError.url))
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        let json = try! JSONEncoder().encode(car)
        request.httpBody = json
        
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                return completion(.failure(CarError.taskError(error: error)))
            } else {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    return completion(.failure(CarError.noData))
                }
                return completion(.success(()))
            }
            }.resume()
    }
}
