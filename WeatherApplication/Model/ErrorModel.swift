//
//  ErrorModel.swift
//  WeatherApplication
//
//  Created by Rachana  on 25/05/23.
//

import Foundation

struct ErrorModel {
    var cod: String
    var message: String
    
    init(_ json: JSON) {
        message = json["message"].stringValue
        cod = json["cod"].stringValue
    }
}
