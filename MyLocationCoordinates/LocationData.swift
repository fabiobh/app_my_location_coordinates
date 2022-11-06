//
//  LocationData.swift
//  MyLocationCoordinates
//
//  Created by fabiocunha on 05/11/22.
//

import Foundation
import RealmSwift

class LocationData: Object {
    
    @objc dynamic var placeName: String = ""
    @objc dynamic var latitude: Int = 0
    @objc dynamic var longitude: Int = 0
    
    convenience init(placeName: String, latitude: Int, longitude: Int) {
        self.init()
        self.placeName = placeName
        self.latitude = latitude
        self.longitude = longitude
    }
}
