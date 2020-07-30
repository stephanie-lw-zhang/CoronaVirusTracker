//
//  PlacesViewController.swift
//  CoronavirusTracker
//
//  Created by Martin Stoyanov on 4/12/20.
//  Copyright © 2020 Alamance. All rights reserved.
//

import UIKit
import CoreLocation
import SystemConfiguration

class PlacesViewControllerTwo: UITableViewController {
    
  override func viewDidLoad() {
    super.viewDidLoad()
    showAlert()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(newLocationAdded(_:)),
      name: .newLocationSaved,
      object: nil)
  }
  
  @objc func newLocationAdded(_ notification: Notification) {
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return LocationsStorage.shared.locations.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
    let location = LocationsStorage.shared.locations[indexPath.row]
    cell.textLabel?.numberOfLines = 3
    //cell.textLabel?.text = location.description
    let temp = CLLocation.init(latitude: location.latitude, longitude: location.longitude)
    CLGeocoder().reverseGeocodeLocation(temp,  completionHandler: {
               placemarks, error in
                   if error == nil {
                    let placeMark = placemarks!.last
                    cell.textLabel?.text = "\(placeMark?.thoroughfare ?? "thoroughfare")\n\(placeMark?.postalCode ?? "postal code") \(placeMark?.locality ?? "locality")\n\(placeMark?.country ?? "country")"
                   }
                   /*else {
                        DispatchQueue.main.async {
                            let alert1 = UIAlertController(title: "Network Error", message: "Please connect to a network to view the names of your tracked locations.", preferredStyle: .alert)
                            alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert1, animated: true)
                        }
                    print ("error: \(error!)")
                }*/
               })
    
    //cell.textLabel?.text = location.
    cell.detailTextLabel?.text = location.dateString
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 110
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
         let alert = UIAlertController(title: "You aren't connected to the internet.", message: "Please connect to a network and reload the app to view the names of your tracked locations.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
    }

}
