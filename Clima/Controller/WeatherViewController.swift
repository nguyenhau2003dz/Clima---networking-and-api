//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
class WeatherViewController: UIViewController{
    

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchInput: UITextField!
    var weatherManager = WeatherManager()
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate
        locationManager.delegate = self
        weatherManager.delegate = self
        searchInput.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    

}
//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate{
    //nhan nut search
    @IBAction func searchPress(_ sender: UIButton) {
        //close keyboard
        searchInput.endEditing(true)
        print(searchInput.text!)
    }
    
    
   // nhan nut enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //close keyboard
        searchInput.endEditing(true)
        print(searchInput.text!)
        return true;
    }
    
    // truong van ban nen ket thuc edit
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
            // goi end edit
        }else{
            searchInput.placeholder = "Input something"
            return false
        }
    }
    
    //end edit
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchInput.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchInput.text = ""
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    //delegate
    func didUpdateWeather(_ weatherMangager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    //delegate
    func didFailWithError(error: any Error) {
        print(error)
    }
}


//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longtitude: long)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
