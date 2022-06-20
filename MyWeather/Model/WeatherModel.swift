//
//  WeatherModel.swift
//  MyWeather
//
//  Created by Lyudmila Tokar on 12/14/21.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temprature: Double
    
    var tempratureString: String {
        return String(format: "%.1f", temprature) + " ℃"
    }
    
    var condition: String {
        switch conditionId {
        case 200...232:
            return "⛈"
        case 300...321:
            return "🌧"
        case 500...531:
            return "☔️"
        case 600...622:
            return "🌨"
        case 701...781:
            return "🌫"
        case 801...804:
            return "☁️"
            
        default:
            return ""
        }
    }
    
}
