//
//  MapViewController.swift
//  Places
//
//  Created by Shivani Dosajh on 25/02/18.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MJSnackBar
import Alamofire
import SwiftyJSON


//1. Get user's current location
//2. Pin the current location
// 3. Pin the Destination Location
// 4. Draw Route Between locations 

class MapViewController: UIViewController , GMSMapViewDelegate {
    
    var placeObject : PlacesObject?
    var rectangle = GMSPolyline()
    var snackbar : MJSnackBar!
    var placesClient : GMSPlacesClient!
    
    // To get the user's current location
    var locationManager = CLLocationManager() {
        didSet {
            locationManager.delegate = self
            
        }
    }
    
    var initialLocation : CLLocation!
    
    
    
    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            // Static location Pin ( Source)
            let camera = GMSCameraPosition.camera(withLatitude: (placeObject?.xcoordinate)!, longitude: (placeObject?.yCoordinate)!, zoom: 6)
            mapView.camera = camera
            setMarkerOnTheMap(latitiude: placeObject?.xcoordinate,
                              longitude: placeObject?.yCoordinate ,
                              color: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1) ,
                              title : placeObject?.name ?? "" )
        }
    }
    //MARK : Map Related Methods
    
    // Draw Pin Location on the map
    func setMarkerOnTheMap(latitiude : Double? , longitude : Double?,color : UIColor , title : String ) {
        let marker = GMSMarker()
        
        if let lat = latitiude , let long =  longitude {
            marker.position = CLLocationCoordinate2DMake(lat, long)
            marker.icon = GMSMarker.markerImage(with: color)
            marker.title = title
            marker.map = mapView
        }
        
    }

  // to draw navigation route
    func drawPath()  {
        // retrieving the coordinates
        let destinationCoordinates = "\(placeObject!.xcoordinate!),\(placeObject!.yCoordinate!)"
        let userLocationCoordinates = "\(initialLocation.coordinate.latitude),\(initialLocation.coordinate.longitude)"
        
        // api Call
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(userLocationCoordinates)&destination=\(destinationCoordinates)&mode=driving"
        print(urlString)
        Alamofire.request(urlString).responseJSON {[weak self] (response) in
            
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let json = try? JSON(data: response.data!)
            
            if let routes = json?["routes"].arrayValue , !routes.isEmpty {
            
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.blue
                polyline.map = self?.mapView
                
                // configuring snackbar
                
                let message = "Distance : \(route["legs"][0]["distance"]["text"]) | Duration : \(route["legs"][0]["duration"]["text"])"
                let snackbarData = MJSnackBarData(message: message)
                self?.snackbar.show(data: snackbarData, onView: (self?.view)!)
            }
            }
            else {
                let snackBarData = MJSnackBarData(message : "No Routes Available")
                self?.snackbar.show(data: snackBarData, onView: (self?.view)!)
            }
            
            
        }
        
        
    }
    //MARK : View Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Drawing the route from source to destination
        snackbar = MJSnackBar(onView: view)
        // For use when the app is open & in the background
        locationManager.requestAlwaysAuthorization()
        
        // For use when the app is open
        locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
    }


override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}
}

//MARK : Location Manager Delegates
extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // setting user current location on map
        initialLocation = CLLocation(latitude: manager.location!.coordinate.latitude,
                                     longitude: manager.location!.coordinate.longitude)
        setMarkerOnTheMap(latitiude: initialLocation.coordinate.latitude,
                          longitude: initialLocation.coordinate.longitude,
                          color: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) ,
                          title: "Current Location")
        //draw route
        drawPath()

        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let snackBarData = MJSnackBarData(message: "Failed to retrieve location")
        snackbar.show(data: snackBarData, onView: view)
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
        print(error?.localizedDescription ?? "")
    }
    
}

