//
//  WeatherController.swift
//  CurrentWeatherApp
//
//  Created by Ivan Ramirez on 2/3/22.
//

import Foundation


struct WeatherController {
    
    //Our Goal
    //https://api.openweathermap.org/data/2.5/weather?lat=40.524670&lon=-111.863823&appid=a715b4215a6ddc28e9eb0d95ea296611&units=imperial
    
    //a715b4215a6ddc28e9eb0d95ea296611
    
    private let baseURL = "https://api.openweathermap.org"
    
    //MARK: - Fetch Function
    func fetchWeather(lat: String, lon: String, completion: @escaping(Result<WeatherInfo, NetworkingError>)-> Void){
        guard var url = URL(string: baseURL) else {
            completion(.failure(.badBaseURL))
            return
        }
        
        url.appendPathComponent("data")
        url.appendPathComponent("2.5")
        url.appendPathComponent("weather")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        //query section
        let latQuery = URLQueryItem(name: "lat", value: lat)
        let lonQuery = URLQueryItem(name: "lon", value: lon)
        let appid = URLQueryItem(name: "appid", value: "a715b4215a6ddc28e9eb0d95ea296611")
        let units = URLQueryItem(name: "units", value: "imperial")
        
        //put it all together
        
        components?.queryItems = [latQuery, lonQuery, appid, units]
        guard let builtURL = components?.url else {
            completion(.failure(.badBuiltURL))
            return
        }
        print("✅built url is, \(builtURL)")
        
        //data task
        URLSession.shared.dataTask(with: builtURL) { data, response, error in
            //error first
            if let error = error{
                completion(.failure(NetworkingError.errorWithRequest))
                print("🔴error", error.localizedDescription)
                return
            }
            //response
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                completion(.failure(NetworkingError.invalidResponse))
                return
            }
            //data
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            //weather info
            do{
                let weatherInfo = try JSONDecoder().decode(WeatherInfo.self, from: data)
                completion(.success(weatherInfo))
            }catch{
                completion(.failure(.errorWithRequest))
                print("❌error no data❌", error.localizedDescription)
            }
            
        }.resume()
        
    }
    
}//end of class
