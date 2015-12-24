//
//  LocationManager.swift
//  zalon
//
//  Created by el rs on 12/23/15.
//  Copyright © 2015 hap. All rights reserved.
//

import Foundation
import XCGLogger
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    
    let _log = XCGLogger.defaultInstance()
    var _locationManager:CLLocationManager
    var _whereAmI:CLLocation;

    private override init() {
        _locationManager = CLLocationManager()
        _whereAmI = CLLocation()
        super.init()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _log.debug("initialise")
        _locationManager.requestWhenInUseAuthorization()
        // just ask for once
        _locationManager.requestLocation()
    }
    
    func isSameLocation(loc1:CLLocation, loc2:CLLocation) -> Bool {
        return loc1.coordinate.latitude==loc2.coordinate.latitude && loc1.coordinate.longitude==loc2.coordinate.longitude
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations);
        if(!isSameLocation(_whereAmI, loc2:locations[0])) {
            _whereAmI = locations[0]
            _log.info("Location updated:\(_whereAmI)")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("LocationManager - Failed:\(error)");
    }

    deinit {
        _log.debug("deinitialise")
    }
}