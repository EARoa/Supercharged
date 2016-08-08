//
//  ViewController.swift
//  Supercharged
//
//  Created by Efrain Ayllon on 8/7/16.
//  Copyright © 2016 Efrain Ayllon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var detailedView :UIView!
    @IBOutlet weak var mapView :MKMapView!
    @IBOutlet weak var amenitiesLabel :UILabel!

    var locations = [SuperchargerLocations]()
    var locationManager :CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAPI()
        mapSetup()
        
    }
    
    
    private func mapSetup(){
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.mapView.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true

    }
    
    private func loadAPI() {
        let myAPI = "https://www.tesla.com/all-locations?type=destination_charger"
        guard let url = NSURL(string: myAPI) else {
            fatalError("Invalid URL")
        }
        
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url) { (data :NSData?, response :NSURLResponse?, error :NSError?) in
            guard let jsonResult = NSString(data: data!, encoding: NSUTF8StringEncoding) else {
                fatalError("Unable to format data")
            }
            
            
            let superchargerResponse = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [NSDictionary!]
            for item in superchargerResponse {
                let locations = SuperchargerLocations()
                locations.nid = item.valueForKey("nid") as? String
                locations.location_id = item.valueForKey("location_id") as? String
                locations.title = item.valueForKey("title") as? String
                locations.open_soon = item.valueForKey("open_soon") as? String
                locations.address = item.valueForKey("address") as? String
                locations.address_line_1 = item.valueForKey("address_line_1") as? String
                locations.address_line_2 = item.valueForKey("address_line_2") as? String
                locations.address_notes = item.valueForKey("address_notes") as? String
                locations.postal_code = item.valueForKey("postal_code") as? String
                locations.city = item.valueForKey("city") as? String
                locations.province_state = item.valueForKey("province_state") as? String
                locations.country = item.valueForKey("country") as? String
                locations.latitude = item.valueForKey("latitude") as? String
                locations.longitude = item.valueForKey("longitude") as? String
                locations.region = item.valueForKey("region") as? String
                locations.sub_region = item.valueForKey("sub_region") as? String
                locations.number = item.valueForKey("number") as? String
                locations.hours = item.valueForKey("hours") as? String
                locations.chargers = item.valueForKey("chargers") as? String
                locations.amenities = item.valueForKey("amenities") as? String
                self.locations.append(locations)
            }
            print(self.locations)
            dispatch_async(dispatch_get_main_queue(), {
                for items in self.locations {

//                    print ("Lat: \(items.latitude), Long: \(items.longitude)")
                    let pinAnnotation = MKPointAnnotation()
                    pinAnnotation.title = items.title
                    let myLat = Double(items.latitude)
                    let myLong = Double(items.longitude)

                    pinAnnotation.coordinate = CLLocationCoordinate2D(latitude: myLat!, longitude: myLong!)
                    self.mapView.addAnnotation(pinAnnotation)
                }
            })
            }.resume()
    
        

    }

    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        if let annotationView = views.first {
            if let annotation = annotationView.annotation {
                if annotation is MKUserLocation {
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 2000, 2000)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }

    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var superchargerAnnotationView = self.mapView.dequeueReusableAnnotationViewWithIdentifier("SuperchargerAnnotationView")
        if superchargerAnnotationView == nil {
            superchargerAnnotationView = SuperchargerAnnotationView(annotation: annotation, reuseIdentifier: "SuperchargerAnnotationView")
        }
        let pointImageView = UIImageView(image: UIImage(named: "pinpoint"))
        return superchargerAnnotationView
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

