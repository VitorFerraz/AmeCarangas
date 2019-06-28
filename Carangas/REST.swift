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

    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void) {
        guard let url = URL(string: basePath) else {
            onError(CarError.url)
            return
        }
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                onError(CarError.taskError(error: error! as NSError))
            } else {
                guard let response = response as? HTTPURLResponse else {
                    onError(CarError.noResponse)
                    return
                }
                if response.statusCode == 200 {
                    guard let data = data else {
                        onError(CarError.noData)
                        return
                    }
                    do {
                        let cars = try JSONDecoder().decode([Car].self, from: data)
                        onComplete(cars)
                    } catch {
                        onError(CarError.invalidJSON)
                    }
                    
                } else {
                    onError(CarError.responseStatusCode(code: response.statusCode))
                }
            }
        }.resume()
    }
    
    class func saveCar(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .save, completion: onComplete)
    }
    
    class func updateCar(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .update, completion: onComplete)
    }

    class func deleteCar(car: Car, onComplete: @escaping (Bool) -> Void) {
        applyOperation(car: car, operation: .delete, completion: onComplete)
    }
    
    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void) {
        guard let url = URL(string: FIPEPath) else {
            onComplete(nil)
            return
        }
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                onComplete(nil)
            } else {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
                    onComplete(nil)
                    return
                }
                if let brands = try? JSONDecoder().decode([Brand].self, from: data) {
                    onComplete(brands)
                } else {
                    onComplete(nil)
                }
            }
        }.resume()
    }

    private class func applyOperation(car: Car, operation: RESTOperation, completion: @escaping (Bool) -> Void) {
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
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        let json = try! JSONEncoder().encode(car)
        request.httpBody = json
        
        session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse, let data = data, response.statusCode == 200 else {
                    completion(false)
                    return
                }
                print("Operação efetuada com sucesso:")
                if let newCar = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) {
                    print("Car:", newCar)
                }
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}
