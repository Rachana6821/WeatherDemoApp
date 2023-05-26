//
//  TemperatureConversions.swift
//  WeatherApplication
//
//  Created by Rachana  on 26/05/23.
//

import Foundation
func convertToCelsiusFromKelvin(kelvin: Double) -> Double {
    return kelvin - 273.15
}

func convertToFahrenheitFromKelvin(kelvin: Double) -> Double {
    let celsius = convertToCelsiusFromKelvin(kelvin: kelvin)
    return celsius * 9/5 + 32
}
func roundTemperature(_ temperature: Double) -> Double {
    let decimalPlaces = 2
    let multiplier = pow(10.0, Double(decimalPlaces))
    let truncatedValue = Double(Int(temperature * multiplier)) / multiplier
    return truncatedValue
}
