// This file was generated from JSON Schema using codebeautify, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome2 = try Welcome2(json)

import Foundation

// MARK: - WeatherModel
struct WeatherModel:Codable {
    var coord: Coord?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
    var timezone, id: Int?
    var name: String?
    var cod: Int?
    
 
    
    // MARK: - Clouds
    struct Clouds:Codable {
        var all: Int?
        
    }
    
    // MARK: - Coord
    struct Coord:Codable {
        var lon, lat: Double?
       
    }
    
    // MARK: - Main
    struct Main:Codable {
        var temp, feelsLike, tempMin, tempMax: Double?
        var pressure, humidity, seaLevel, grndLevel: Int?
       
    }
    
    // MARK: - Sys
    struct Sys:Codable {
        var type, id: Int?
        var country: String?
        var sunrise, sunset: Int?
        
    }
    
    
    // MARK: - Weather
    struct Weather:Codable {
        var id: Int?
        var main, description, icon: String?
       
        
        
    }
    
    // MARK: - Wind
    struct Wind:Codable {
        var speed: Double?
        var deg: Int?
        var gust: Double?
      
        
    }
    
}
