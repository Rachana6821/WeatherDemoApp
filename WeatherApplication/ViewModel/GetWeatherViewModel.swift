//
//  GetWeatherViewModel.swift
//  WeatherApplication
//
//  Created by Rachana  on 25/05/23.
//

import Foundation
import SwiftUI
import Combine

class GetWeatherViewModel: ObservableObject{
    
    @Published var weatherData: WeatherModel?
    var locationManager = LocationManager()
    
    func getWeather(for place: String, _ completion: @escaping (_ weather: WeatherModel?) -> Void) {
        locationManager.getCoordinates(for: place) { location in
            if let latitude = location?.latitude, let longitude = location?.longitude {
                guard let url = URL(string: NetworkManager.APIURL.weatherRequest(for: "\(latitude)", long: "\(longitude)")) else {
                    completion(nil)
                    return
                }
                
                print("URL\(url)")
                
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
                    guard let data = data else {
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let weatherObject = try decoder.decode(WeatherModel.self, from: data)
                        DispatchQueue.main.async {
                            self.weatherData = weatherObject
                        }
                        completion(weatherObject)
                        
                        print("Weather Object : \(weatherObject)")                        
                    } catch {
                        print(error.localizedDescription)
                        completion(nil)
                    }
                }.resume()
            }else{
                completion(nil)
            }
           
        }
    }
}



