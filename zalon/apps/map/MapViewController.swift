//
//  MapViewController.swift
//  zalon
//
//  Created by el rs on 12/23/15.
//  Copyright © 2015 hap. All rights reserved.
//

import Foundation
import MapKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class ServiceAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
}

class WeatherResponse: Mappable {
    var location: String?
    var threeDayForecast: [Forecast]?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        location <- map["location"]
        threeDayForecast <- map["three_day_forecast"]
    }
}

class Forecast: Mappable {
    var day: String?
    var temperature: Int?
    var conditions: String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        day <- map["day"]
        temperature <- map["temperature"]
        conditions <- map["conditions"]
    }
}


class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var _map: MKMapView!
    
    var _locationManager:LocationManager! = LocationManager.sharedInstance;
    var _annotations = [MKAnnotation]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMap()
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
        Alamofire.request(.GET, URL).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let wr = Mapper<WeatherResponse>().map(value);
                    print("Object: \(wr)")
                    print("JSON: \(json)")
                }
            case .Failure(let error):
                print(error)
            }
        }
        
        let parameters = ["ll": "37.788022,-122.399797", "category_filter": "beautysvc", "radius_filter": "100", "sort": "0", "term":"salon"]
        /*
        let client = YelpClient();
        client.searchPlacesWithParameters(parameters, successSearch: { (data, response) -> Void in
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
            }, failureSearch: { (error) -> Void in
                print(error)
        })
        */
        YelpRouter.init()
        Alamofire.request(YelpRouter.Search(parameters)).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                }
            case .Failure(let error):
                print(error)
            }
        }


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