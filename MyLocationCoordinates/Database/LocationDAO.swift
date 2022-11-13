//
//  LocationDatabase.swift
//  MyLocationCoordinates
//
//  Created by fabiocunha on 11/11/22.
//

import RealmSwift

struct LocationDAO {
    
    let realm = try! Realm()
    
    func saveRealmData(latitude:Double, longitude:Double) {
        let myLocation = LocationData(placeName: "Default Location Name", latitude: latitude, longitude: longitude)
        realm.beginWrite()
        realm.add(myLocation)
        try! realm.commitWrite()
        print("data saved")
                
    }
    
    func getRealmData() -> Results<LocationData> {
        let location = realm.objects(LocationData.self)
        return location
    }
    
    func deleteAllRealmData() {
        realm.beginWrite()
        realm.delete(realm.objects(LocationData.self))
        try! realm.commitWrite()
    }
    
    func deleteRealmSpecificObjectById(_ locationId: String) {
        //print("locationId: \(locationId)")
        try! realm.write {
            let location = realm.objects(LocationData.self).where {
                $0.locationID == locationId
            }
            realm.delete(location)
        }
    }
    
    func updateRealmSpecificObjectById(_ locationId: String, _ placeName: String) {
        //print("locationId: \(locationId)")
        let location = realm.objects(LocationData.self).where {
            $0.locationID == locationId
        }.first!
        try! realm.write {
            location.placeName = placeName
        }
    }
    
}
