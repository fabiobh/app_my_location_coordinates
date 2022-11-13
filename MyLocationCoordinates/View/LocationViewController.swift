//
//  LocationViewController.swift
//  CDA
//
//  Created by fabiocunha on 02/03/22.
//  Copyright © 2022 Prodesp. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import RxSwift
import RxCocoa
/*
 use a LocationViewController ao herdar uma UIViewController para mostrar a tela de solicitação de permissão
 de uso do Sensor GPS e também para capturar as coordenadas e salvar no UserDefaults
 */

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let myCurrentStatusValue: BehaviorRelay = BehaviorRelay<String>(value: "")
    let myCurrentLatitude: BehaviorRelay = BehaviorRelay<Double>(value: (0.0))
    let myCurrentLongitude: BehaviorRelay = BehaviorRelay<Double>(value: (0.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("___ LocationViewController viewDidLoad")
        //getLocation()
    }
    
    func getLocation() {
        print("___ LocationViewController getLocation")
        // 1
//        let locationManager = CLLocationManager()
//        let status = locationManager.authorizationStatus
        let status = CLLocationManager().authorizationStatus
        
        switch status {
            case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                    return
                
            case .denied, .restricted:
                let alert = UIAlertController(title: "Location services are deactivated", message: "Please, enable Location Services on the device configuration", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                
                present(alert, animated: true, completion: nil)
                return
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
                print("erro desconhecido")
        }
        
        // 3
        locationManager.delegate = self
        locationManager.startUpdatingLocation() // função didUpdateLocations controla quando GPS capta atualização do Sensor
        //locationManager.startMonitoringSignificantLocationChanges()
        
    }
    
    
    
    
    
    
    // verifica localização do dispositivo
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            manager.distanceFilter = 50 // distance changes you want to be informed about (in meters)
            manager.desiredAccuracy = 10 // biggest approximation you tolerate (in meters)
            //manager.activityType = .automotiveNavigation // .automotiveNavigation will stop the updates when the device is not moving
            showLocationPosition(currentLocation)
        }
    }
    
    fileprivate func showLocationPosition(_ currentLocation: CLLocation) {
        print("currentLocation: \(currentLocation)")
        print("latitude: \(currentLocation.coordinate.latitude)")
        myCurrentStatusValue.accept("""
          Current Latitude: \(currentLocation.coordinate.latitude)
          Current Longitude: \(currentLocation.coordinate.longitude)
        """)
        myCurrentLatitude.accept(currentLocation.coordinate.latitude)
        myCurrentLongitude.accept(currentLocation.coordinate.longitude)
        print("horizontalAccuracy: \(currentLocation.horizontalAccuracy.magnitude)")
        print("currentLatitude: \(myCurrentStatusValue.value)")
        //UserDefaults.standard.set(currentLocation.coordinate.latitude, forKey: RESconstantes.LATITUDE_USER)
        //UserDefaults.standard.set(currentLocation.coordinate.longitude, forKey: RESconstantes.LONGITUDE_USER)
    }
    
    // indica se houve erro no sensor de localização do dispositivo
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager error")
        print(error)
    }
    
}
