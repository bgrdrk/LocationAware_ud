//
//  ViewController.swift
//  Location Aware
//
//  Created by Remis on 2020-11-20.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var nearAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        self.latitude.text = String(location.coordinate.latitude)
        self.longitude.text = String(location.coordinate.longitude)
        self.course.text = String(location.course)
        self.speed.text = String(location.speed) // meters per second
        self.altitude.text = String(location.altitude) // meters
        
        setMap(for: location)
        extractAddress(from: location)
        
    }
    
    func setMap(for location: CLLocation) {
        
        let lanDelta: CLLocationDegrees = 0.03
        let lonDelta: CLLocationDegrees = 0.03
        let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)
        let coordinates = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegion(center: coordinates, span: span)

        map.setRegion(region, animated: true)
        
    }
    
    func extractAddress(from location: CLLocation) {
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let errorr = error {
                print("Error while retrieving location data, \(errorr)")
            } else {
                if let placemark = placemarks?[0] {
                    
                    var address = ""
                    
                    if placemark.subThoroughfare != nil {
                        address += placemark.subThoroughfare! + " "
                    }
                    
                    if placemark.thoroughfare != nil {
                        address += placemark.thoroughfare! + ", "
                    }
                    
                    if placemark.subLocality != nil {
                        address += placemark.subLocality! + " "
                    }
                    
                    if placemark.subAdministrativeArea != nil {
                        address += placemark.subAdministrativeArea! + ", "
                    }
                    
                    if placemark.postalCode != nil {
                        address += placemark.postalCode! + " "
                    }
                    
                    if placemark.country != nil {
                        address += placemark.country! + " "
                    }
                    
                    self.nearAddress.text = address
                }
            }
        }
        
    }

}

