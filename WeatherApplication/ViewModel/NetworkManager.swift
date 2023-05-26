//
//  NetworkManager.swift
//  WeatherApplication
//
//  Created by Rachana  on 25/05/23.
//

import Foundation
import UIKit

class NetworkManager: NSObject {
    
    struct Key {
        
        static let APIKey: String = "1fbdecf71fb9106e94e66e6089245177" // Enter your darkSky API key here
        //static let googleMaps: String = "" // Enter your google maps API key here
        
    }
    
    struct APIURL {
        static func weatherRequest(for search: String) -> String {
            return "https://api.openweathermap.org/data/2.5/weather?q=\(search)&appid=\(NetworkManager.Key.APIKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
        }
    }
    
    
    
}
