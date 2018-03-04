//
//  LocationDescriptionModel.swift
//  Places
//
//  Created by Shivani Dosajh on 25/02/18.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
// Data Model for location Descripiton View

protocol LocationDescriptionModel {
    
    func fetchWeatherData( latitude : Double , longitude : Double , completionHandler : @escaping (WeatherData?) -> Void )
}


//Implementation of the data model protocol

class LocationDescriptionModelImplementation : LocationDescriptionModel {
    
    // returns corresponding url string for the selected location
   private func getUrlString( lat : Double , long : Double)  -> String {
        
        let str = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&units=metric&appid=\(Constants.openWeatherAppID)"
        print(str)
        return str
    }
    
    // returns weather data by calling api 
    func fetchWeatherData( latitude : Double , longitude : Double , completionHandler : @escaping (WeatherData?) -> Void ) {
        
        if  let url = URL(string: getUrlString(lat: latitude, long: longitude)) {
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: nil).validate().responseObject { (response : DataResponse<WeatherData>) in
                switch response.result {
                case .failure(let error) :
                    print(error.localizedDescription)
                    completionHandler(nil)
                case .success(_) :
                    completionHandler(response.result.value)
                }
                
            }
        }
    }
}


