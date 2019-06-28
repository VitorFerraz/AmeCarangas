//
//  CarService.swift
//  Carangas
//
//  Created by Vitor Ferraz Varela on 27/06/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Moya
enum CarService {
    case loadCars
    case save(car: Car)
    case update(car: Car)
    case delete(car: Car)
    case loadBrands
}

extension CarService: TargetType {
    var baseURL: URL {
        switch self {
        case .loadBrands:
            return NetworkConstants.URLs.fipeURL
        default:
            return NetworkConstants.URLs.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .loadBrands:
            return "/api/1/carros/marcas.json"
        case .delete(let car),
             .update(let car),
             .save(let car):
            return "/cars/\(car._id ?? "")"
        case .loadCars:
            return "/cars"
        }
    }
    
    var method: Method {
        switch self {
        case .delete:
            return .delete
        case .loadBrands,
             .loadCars:
            return .get
        case .save:
            return .post
        case .update:
            return .put
        }
    }
    
    var sampleData: Data {
        switch self {
        case .loadCars:
            return [Car].fromJSON("CarsMock")
        default:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .delete(let car as Encodable),
             .update(let car as Encodable),
             .save(let car as Encodable):
            return .requestJSONEncodable(car)
        case .loadBrands,
             .loadCars:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return NetworkConstants.Headers.contentTypeApplicationJSON
    }
    
    var validationType: ValidationType {
        return ValidationType.successCodes
    }
}
