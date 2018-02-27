//
//  LocationDescriptionViewModel.swift
//  Places
//
//  Created by Shivani Dosajh on 25/02/18.
//

import Foundation

protocol LocationDescriptionViewDelegate : Loadable {
    func refreshViews()
}

protocol LocationDescriptionViewModel {
    var model : LocationDescriptionModel? { get set}
    var viewDelegate : LocationDescriptionViewDelegate? {get set}
    var placeObject : PlacesObject { get set}
    var weatherData : WeatherData? {get set}
    
}

class LocationDescriptionViewModelImplemenatation : LocationDescriptionViewModel {
    var placeObject: PlacesObject {
        didSet {
            print(placeObject)
        }
    }

     var weatherData : WeatherData? {
        didSet {
            print(weatherData)
            viewDelegate?.refreshViews()
        }
    }
    var model: LocationDescriptionModel? {
        didSet {
            viewDelegate?.showLoader()
            model?.fetchWeatherData(latitude: placeObject.xcoordinate!, longitude: placeObject.yCoordinate!, completionHandler: { [weak self](weatherData) in
                self?.weatherData = weatherData
                self?.viewDelegate?.hideLoader()
                
            })
        }
    }
    
    var viewDelegate: LocationDescriptionViewDelegate?
    
    init(placeObject : PlacesObject) {
        self.placeObject = placeObject
    }
    
}
    
    

