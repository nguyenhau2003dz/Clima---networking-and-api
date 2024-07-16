import Foundation
import CoreLocation
protocol WeatherManagerDelegate{
   func didUpdateWeather(_ weatherMangager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager{
    let urlWeather = "https://api.openweathermap.org/data/2.5/weather?appid=463389f44f777c36cb51619c0588ac57&units=metric"
    
    var delegate: WeatherManagerDelegate?;
    
    func fetchWeather(cityName: String){
        let urlString = "\(urlWeather)&q=\(cityName)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees){
        let urlString = "\(urlWeather)&lat=\(latitude)&lon=\(longtitude)"
        performRequest(urlString: urlString)
    }
    
    
    
    func performRequest(urlString: String){
        // 1. Create url
        if let url = URL(string: urlString){
            // 2. Create url session
            let session = URLSession(configuration: .default)
            //3. give a session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.parseJson(safeData){
                        //delegate and protocol
                        //cu goi didUp ma chua biet class nao duoc delegate
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
                
            }      //4. start a task
            task.resume()
        }
    }
    func parseJson(_ data: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(WeatherData.self, from: data)
            let id = decodeData.weather[0].id
            let tempearature = decodeData.main.temp
            let name = decodeData.name
            
            
            let weather = WeatherModel(conditionId: id, temperature: tempearature, cityName: name)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    }
