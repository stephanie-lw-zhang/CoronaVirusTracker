//
//  MapViewController.swift
//  CoronavirusTracker
//
//  Created by codeplus on 3/29/20.
//  Copyright © 2020 Alamance. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SystemConfiguration

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAlert()
			let locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
//       locationManager.startUpdatingLocation()
				mapView.delegate = self
        mapView.showsUserLocation = true
        
				mapView.userTrackingMode = .follow
				let annotations = LocationsStorage.shared.locations.map { annotationForLocation($0) }
				mapView.addAnnotations(annotations)
				NotificationCenter.default.addObserver(self, selector: #selector(newLocationAdded(_:)), name: .newLocationSaved, object: nil)


        // Do any additional setup after loading the view.
    }
    
	@IBAction func addPressed(_ sender: Any) {
		guard let currentLocation = mapView.userLocation.location else {
			return
		}
		LocationsStorage.shared.saveCLLocationToDisk(currentLocation)

	}
	
		
		func annotationForLocation(_ location: Location) -> MKAnnotation {
			let annotation = MKPointAnnotation()
			annotation.title = location.dateString
			annotation.coordinate = location.coordinates
			return annotation
		}
		
		@objc func newLocationAdded(_ notification: Notification) {
			guard let location = notification.userInfo?["location"] as? Location else {
				return
			}
			
			let annotation = annotationForLocation(location)
			mapView.addAnnotation(annotation)

		}
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }

    func showAlert() {
        if !isInternetAvailable() {
         let alert = UIAlertController(title: "You aren't connected to the internet.", message: "Please connect to a network and reload the app to track your location.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }

}
