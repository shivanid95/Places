//
//  PlaceObject.swift
//  Places
//
//  Created by Shivani Dosajh on 25/02/18.
//

import Foundation
import ObjectMapper
import Alamofire

// Structure containing  location data fetched from database

struct PlacesObject : Mappable {
    
    var name        : String?
    var xcoordinate : Double?
    var yCoordinate : Double?
    var description : String?
    var imageUrl    : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name        <- map["name"]
        xcoordinate <- map["xCoord"]
        yCoordinate <- map["yCoord"]
        description <- map["description"]
        imageUrl    <- map["imageUrl"]
    }
    
    
    
}
