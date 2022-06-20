//
//  MyWeatherManager.swift
//  MyWeather
//
//  Created by Lyudmila Tokar on 12/10/21.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: MyWeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct MyWeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=6074a3dd3d8b25031778894871d61033"
    
    var delegate: WeatherManagerDelegate?
    
    func fechWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fechWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //Create URL from the string
        if let url = URL(string: urlString) {
            
            //Create URL session
            let session = URLSession(configuration: .default)
            
            //Give url session a task
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                //data parse
                if let safeData = data {
                    // let dataString = String(data: safeData, encoding: .utf8) //to see data in app by printing
                    
                    if let returnedWeather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: returnedWeather)
                    }
                    
                }
            })
            //Start the task
            task.resume()
            
        }
    }
    
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temprature: temp)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}


