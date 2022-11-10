//
//  LocationDetailViewController.swift
//  MyLocationCoordinates
//
//  Created by fabiocunha on 08/11/22.
//

import Foundation
import UIKit
import RealmSwift
import RxSwift
import RxRelay

class LocationDetailViewController: UIViewController {
    
    var detailsStackView: UIStackView = {
        //let lb = UIStackView(frame: CGRect(x: 100, y: 50, width: 200, height: 150))
        let lb = UIStackView()
        lb.translatesAutoresizingMaskIntoConstraints = false        
        lb.backgroundColor = UIColor(rgb: 0x161f28)
        return lb
    }()
    
    var currentLatitude: UILabel = {
        //let lb = UILabel()
        //lb.translatesAutoresizingMaskIntoConstraints = false
        let lb = UILabel(frame: CGRect(x: 50, y: 150, width: 200, height: 150))
        lb.text = "Current Latitude:"
        lb.textColor = UIColorConstant.yellowColor
        return lb
    }()
    
    var currentLongitude: UILabel = {
        //let lb = UILabel()
        //lb.translatesAutoresizingMaskIntoConstraints = false
        let lb = UILabel(frame: CGRect(x: 50, y: 250, width: 200, height: 150))
        lb.text = "Current Latitude:"
        lb.textColor = UIColorConstant.yellowColor
        return lb
    }()
    
    var buttonDeleteCoordinate: UIButton = {
        //let bt = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Delete Coordinate", for: .normal)
        bt.backgroundColor = UIColor(rgb: 0x3598db)
        
        return bt
    }()
    
    var showMapCoordinate: UIButton = {
        //let bt = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Show on Map", for: .normal)
        bt.backgroundColor = UIColor(rgb: 0x3598db)
        
        return bt
    }()
    
    let realm = try! Realm()
    let disposeBag = DisposeBag()
    //let latitudeString: BehaviorRelay = BehaviorRelay<String>(value: "")
    let locationData: BehaviorRelay = BehaviorRelay<CoordinateCellDataModel>(
        value: CoordinateCellDataModel(locationId: "", namePlace: "", latitude: 0, longitude: 0)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Location Detail"
        self.view.addSubview(detailsStackView)
        self.view.addSubview(currentLatitude)
        self.view.addSubview(currentLongitude)
        
        self.view.addSubview(buttonDeleteCoordinate)
        buttonDeleteCoordinate.addTarget(self, action: #selector(deleteCoordinateFunction), for: .touchUpInside)
        self.view.addSubview(showMapCoordinate)
        showMapCoordinate.addTarget(self, action: #selector(showMapCoordinateFunction), for: .touchUpInside)

        configRxComponents()
                
    }
    
    func configRxComponents() {
        locationData.map({
            locationDataObject in
            print("locationDataObject: \(locationDataObject)")
            return locationDataObject.locationId
        })
            .bind(to: currentLatitude.rx.text)
        .disposed(by: disposeBag)
        
        //latitudeString.bind(to: currentLatitude.rx.text)
        //.disposed(by: disposeBag)
    }
    
    func deleteDataRealm() {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setContrainsts()
    }
    
    @objc func deleteCoordinateFunction() {
        print("deleteCoordinateFunction")
        
        locationData.subscribe(onNext: {
            locationDataObject in
            print("name: \(locationDataObject.locationId)")
            self.deleteRealmSpecificObjectById(locationDataObject.locationId)
            self.navigationController?.popViewController(animated: true)
        })
        .disposed(by: disposeBag)
                
    }
    
    @objc func showMapCoordinateFunction() {
        print("show map")
    }
    
    func setContrainsts() {
        detailsStackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        detailsStackView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        detailsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
               
        showMapCoordinate.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        showMapCoordinate.heightAnchor.constraint(equalToConstant: 50).isActive = true
        showMapCoordinate.bottomAnchor.constraint(equalTo: buttonDeleteCoordinate.topAnchor, constant: -10).isActive = true
        
        buttonDeleteCoordinate.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        buttonDeleteCoordinate.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonDeleteCoordinate.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        
        
        
    }
}
