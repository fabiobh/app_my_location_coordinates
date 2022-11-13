//
//  LocationViewModel.swift
//  MyLocationCoordinates
//
//  Created by fabiocunha on 12/11/22.
//

import RxSwift
import RxCocoa

class LocationViewModel {
    
    let myCountLocationValue: BehaviorRelay = BehaviorRelay<String>(value: "")
    var tableViewItems = BehaviorRelay.init(value:
        [
            CoordinateCellDataModel(locationId: "", namePlace: "---", latitude: 0.0, longitude: 0.0),
            //CoordinateCellDataModel(namePlace: "ccc", latitude: 3, longitude: 3)
        ]
    )
    
    func getRealmDataToTableView() {
        
        let locations = LocationDAO().getRealmData()
        print("locations count: \(locations.count)")
        dump(locations)
        var locationList: [CoordinateCellDataModel] = []
        
        for location in locations {
            locationList.append(
                CoordinateCellDataModel(locationId: location.locationID,
                                        namePlace: location.placeName,
                                        latitude: location.latitude,
                                        longitude: location.longitude)
            )
        }
        tableViewItems.accept(locationList)
        myCountLocationValue.accept("  Locations saved: \(locationList.count)")
    }
        
}
