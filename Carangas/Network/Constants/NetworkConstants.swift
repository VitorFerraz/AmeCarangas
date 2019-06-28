//
//  NetworkConstants.swift
//  Carangas
//
//  Created by Vitor Ferraz Varela on 27/06/19.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import UIKit
struct NetworkConstants {
    struct URLs {
        static var baseURL: URL {
            guard let url = URL(string: "https://carangas.herokuapp.com") else {
                fatalError("Error to convert string url to URL")
            }
            return url
        }
        static var fipeURL: URL {
            guard let url = URL(string: "https://fipeapi.appspot.com") else {
                fatalError("Error to convert string url to URL")
            }
            return url
        }
    }
    
    struct Headers {
        static var contentTypeApplicationJSON = ["Content-Type": "application/json"]
    }
}
