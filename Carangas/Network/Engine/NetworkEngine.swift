//
//  NetworkEngine.swift
//  Carangas
//
//  Created by Vitor Ferraz Varela on 27/06/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Moya
class NetworkEngine<Target: TargetType> {
    private var provider: MoyaProvider<Target>

    init(provider: MoyaProvider<Target>) {
        self.provider = provider
    }
    
    func request<T: Codable>(target: Target, completion: @escaping(Result<T, CarError>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let value):
                    do {
                        return completion(Result.success(try JSONDecoder().decode(T.self, from: value.data)))
                    } catch {
                        return completion(Result.failure(CarError.invalidJSON))
                    }
            case .failure(let error):
                return completion(Result.failure(CarError.taskError(error: error)))
            }
        }
    }
    
    func requestVoid(target: Target,
                     completion: @escaping(Result<Void, CarError>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success:
                return completion(Result.success(()))
            case .failure(let error):
                return completion(Result.failure(CarError.taskError(error: error)))
            }
        }
    }
}
