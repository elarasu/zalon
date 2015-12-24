//
//  MapViewController.swift
//  zalon
//
//  Created by el rs on 12/23/15.
//  Copyright © 2015 hap. All rights reserved.
//

import Foundation
import MapKit

class ServiceAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
}

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var _map: MKMapView!
    
    var _locationManager:LocationManager! = LocationManager.sharedInstance;
    var _annotations = [MKAnnotation]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMap()
    }

    // init map view
    func initMap() {
        _map.delegate = self
        _map.mapType = MKMapType.Standard
        _map.showsUserLocation = true
        // set initial location to apple
        let initialLocation = CLLocation(latitude: 37.351022, longitude: -122.021768)
        centerMapOnLocation(initialLocation)
        _annotations.append(ServiceAnnotation(title: "Scurves", coordinate: CLLocationCoordinate2D(latitude: 37.351022, longitude: -122.021768)))
        _annotations.append(ServiceAnnotation(title: "My Saloon", coordinate: CLLocationCoordinate2D(latitude: 37.341022, longitude: -122.031768)))
        _map.addAnnotations(_annotations)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            1000 * 2.0, 1000 * 2.0)
        _map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapViewDidFailLoadingMap(mapView: MKMapView, withError error: NSError) {
        print("Failed to load map");
        print(error);
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("moved the map");
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}