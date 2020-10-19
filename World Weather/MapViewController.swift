//
//  MapViewController.swift
//  World Weather
//
//  Created by Sium on 8/11/17.
//  Copyright © 2017 Refat. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Alamofire
import SwiftyJSON
import CoreLocation

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var mapCountry: String!
    var mapCity: String!
    var latiValue: Double!
    var longiValue: Double!
    
    
    let locationManager = CLLocationManager()
    var currentLatValue = CLLocationDegrees()
    var currentLongValue = CLLocationDegrees()
    var distance = CLLocationDistance()
    
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    @IBOutlet weak var mapLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       
        //for map
        let camera = GMSCameraPosition.camera(withLatitude: latiValue, longitude: longiValue, zoom: 10.0)
        mapView.camera = camera
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        //for marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latiValue, longiValue)
        marker.title = "\(mapCity!)"
        marker.snippet = "\(mapCountry!)"
        marker.map = mapView
        
        getCurrentLocation()
        
        
        distance = calculateDistance(userLat: currentLatValue, userLong: currentLongValue, destinationLat: latiValue, destinationLong: longiValue)
        
        mapLabel.text = "Distance from your location is \(distance) kilometers."
        
        // for back button radious
        backButtonOutlet.layer.cornerRadius = 5
        backButtonOutlet.layer.borderWidth = 2
        backButtonOutlet.layer.borderColor = UIColor.white.cgColor
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //current location
    func getCurrentLocation() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization() // Call the authorizationStatus() class
        
        if CLLocationManager.locationServicesEnabled() { // get my current locations lat, lng
            
            let lat = locationManager.location?.coordinate.latitude
            let long = locationManager.location?.coordinate.longitude
            if let lattitude = lat  {
                if let longitude = long {
                    currentLatValue = lattitude
                    currentLongValue = longitude
                } else {
                    
                }
            } else {
                
                print("problem to find lat and lng")
            }
            
        }
        else {
            print("Location Service not Enabled. Plz enable u'r location services")
        }
    }

    
    
    // distance calculation
    func calculateDistance(userLat: CLLocationDegrees, userLong: CLLocationDegrees, destinationLat: CLLocationDegrees , destinationLong: CLLocationDegrees) -> CLLocationDistance {
        
        let userLocation = CLLocation(latitude: userLat, longitude: userLong)
        let tappedLocation = CLLocation(latitude: destinationLat, longitude: destinationLong)
        let distance = userLocation.distance(from: tappedLocation)/1000
        return distance
    }
    
    
    
    
}
