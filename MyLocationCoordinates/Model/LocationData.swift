//
//  LocationData.swift
//  MyLocationCoordinates
//
//  Created by fabiocunha on 05/11/22.
//

import Foundation
import RealmSwift

class LocationData: Object {
    
    @objc dynamic var locationID = UUID().uuidString
    @objc dynamic var placeName: String = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    convenience init(placeName: String, latitude: Double, longitude: Double) {
        self.init()
        self.placeName = placeName
        self.latitude = latitude
        self.longitude = longitude
    }
        
    override static func primaryKey() -> String? {
      return "locationID"
    }
}
