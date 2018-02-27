//
//  MapViewController.swift
//  Places
//
//  Created by Shivani Dosajh on 25/02/18.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var placeObject : PlacesObject?
    
    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            let camera = GMSCameraPosition.camera(withLatitude: (placeObject?.xcoordinate)!, longitude: (placeObject?.yCoordinate)!, zoom: 6)
            mapView.camera = camera
            setMarkerOnTheMap()
        }
    }
    
    func setMarkerOnTheMap() {
        let marker = GMSMarker()
        if let lat = placeObject?.xcoordinate , let long = placeObject?.yCoordinate {
        marker.position = CLLocationCoordinate2DMake(lat, long)
            marker.title = placeObject?.name
            marker.map = mapView
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
