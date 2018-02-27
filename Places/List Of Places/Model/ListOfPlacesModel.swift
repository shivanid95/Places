//
//  ListOfPlacesModel.swift
//  Places
//
//  Created by Shivani Dosajh on 25/02/18.
//

import Foundation

import FirebaseDatabase
import Firebase
import  ObjectMapper

protocol ListOfPlacesModel {
    
    // returns the array of location data from the firebase database
   func fetchPlaces( completionHandler : @escaping([PlacesObject]?) -> Void)
}

class ListOfPlacesModelImplementation: ListOfPlacesModel {
    
    let referenceToDb = Database.database().reference()
    
    func fetchPlaces( completionHandler : @escaping([PlacesObject]?) -> Void) {
    
        referenceToDb.observe(.value) { (snapshot) in
            print(snapshot)
             let mapper = Mapper<PlacesObject>().mapArray(JSONArray: snapshot.value as! [[String : Any]])
                completionHandler(mapper)
        }
}
    
}
