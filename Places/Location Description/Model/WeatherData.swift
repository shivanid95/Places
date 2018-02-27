//
//  WeatherData.swift
//  Places
//
//  Created by Shivani Dosajh on 26/02/18.
//

import Foundation
import ObjectMapper
struct WeatherData : Mappable{
    
    var weatherDescription : [WeatherDescription]?
    var temprature : Double?
    var pressure   : Double?
    var humidity   : Double?
    var cityName   : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        weatherDescription      <-  map[ "weather" ]
        temprature              <-  map[ "main.temp"]
        pressure                <-  map[ "main.pressure" ]
        humidity                <- map[ "main.humidity" ]
        cityName                <- map["name"]
        
    }
    
    
}

struct WeatherDescription : Mappable {
    
    var icon        : String?
    var description : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        description         <- map["description"]
        icon                <- map["icon"]
    }
    
    
}

