//
//  Location.swift
//  CoronavirusTracker
//
//  Created by Martin Stoyanov on 4/12/20.
//  Copyright © 2020 Alamance. All rights reserved.
//

import Foundation
import CoreLocation

class Location: Codable {
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    return formatter
  }()
  
  var coordinates: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
  
  let latitude: Double
  let longitude: Double
  let date: Date
  let dateString: String
  let description: String
  
  init(_ location: CLLocationCoordinate2D, date: Date, descriptionString: String) {
    latitude =  location.latitude
    longitude =  location.longitude
    self.date = date
    dateString = Location.dateFormatter.string(from: date)
    description = descriptionString
  }
  
  convenience init(visit: CLVisit, descriptionString: String) {
    self.init(visit.coordinate, date: visit.arrivalDate, descriptionString: descriptionString)
  }
}



class LocationsStorage {
  static let shared = LocationsStorage()
  
  private(set) var locations: [Location]
  private let fileManager: FileManager
  private let documentsURL: URL
  
  init() {
    let fileManager = FileManager.default
    documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    self.fileManager = fileManager
    
    let jsonDecoder = JSONDecoder()
    
    let locationFilesURLs = try! fileManager.contentsOfDirectory(at: documentsURL,
                                                                 includingPropertiesForKeys: nil)
    locations = locationFilesURLs.compactMap { url -> Location? in
      guard !url.absoluteString.contains(".DS_Store") else {
        return nil
      }
      guard let data = try? Data(contentsOf: url) else {
        return nil
      }
      return try? jsonDecoder.decode(Location.self, from: data)
    }.sorted(by: { $0.date < $1.date })
  }
  
  func saveLocationOnDisk(_ location: Location) {
    let encoder = JSONEncoder()
    let timestamp = location.date.timeIntervalSince1970
    let fileURL = documentsURL.appendingPathComponent("\(timestamp)")
    
    let data = try! encoder.encode(location)
    try! data.write(to: fileURL)
    
    locations.append(location)
    
    NotificationCenter.default.post(name: .newLocationSaved, object: self, userInfo: ["location": location])
  }
  
  func saveCLLocationToDisk(_ clLocation: CLLocation) {
    let currentDate = Date()
    AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
      if let place = placemarks?.first {
        let location = Location(clLocation.coordinate, date: currentDate, descriptionString: "\(place)")
        self.saveLocationOnDisk(location)
      }
    }
  }
}

extension Notification.Name {
  static let newLocationSaved = Notification.Name("newLocationSaved")
}

