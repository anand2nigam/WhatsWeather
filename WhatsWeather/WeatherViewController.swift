//
//  WeatherViewController.swift
//  WhatsWeather
//
//  Created by Anand Nigam on 21/07/18.
//  Copyright © 2018 Anand Nigam. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    // Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    // UI Links
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    // Instance variables
    let locationManger = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Networking
    
    
    func getWeatherData(url : String, parameters: [String:String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! We got the weather data")
                
                let weatherJSON: JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error : \(response.result.error!)")
                self.cityLabel.text = " Connection Issues"
            }
        }

    }
    
    // MARK:- JSON Parsing
    
    func updateWeatherData(json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconImage = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
        }
    }
    
    // MARK:- UI Updates
    
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = String(weatherDataModel.temperature)
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconImage)
    }
    
    // MARK:- Location Manager Delegate Methods
    
    // func to update the locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManger.stopUpdatingLocation()
            print("Longitude : \(location.coordinate.longitude), Latitude: \(location.coordinate.latitude)")
            
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            
            let parametersForQuery : [String:String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: parametersForQuery)
        }
    }

    // func to handle the error when the location manager unavailable to fetch the location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Weather Unavailable"
    }

}
