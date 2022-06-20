//
//  ViewController.swift
//  MyWeather
//
//  Created by Lyudmila Tokar on 12/6/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    
    var weatherManager = MyWeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTextField.delegate = self
        weatherManager.delegate = self
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        cityTextField.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter a city name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //   print(cityTextField.text!)
        
        if let city = cityTextField.text {
            weatherManager.fechWeather(cityName: city)
        }
        
        cityTextField.text = ""
        cityTextField.placeholder = "Search"
    }
    
    //to do when Return button pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        cityTextField.endEditing(true)
        
        return true
    }
    
    //to dissmiss keyboard when tap anywhere
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: MyWeatherManager, weather: WeatherModel) {
        print(weather.tempratureString)
        
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.degreesLabel.text = weather.tempratureString
            self.weatherLabel.text = weather.condition
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - Get user's location

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            
            locationManager.stopUpdatingLocation()
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fechWeather(latitude: lat, longitude: lon)
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
  @IBAction func locationButtonPressed(_ sender: UIButton) {
    
    locationManager.requestLocation()
        
    }
}
