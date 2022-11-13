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
    
    /*
    var detailsStackView: UIStackView = {
        //let lb = UIStackView(frame: CGRect(x: 100, y: 50, width: 200, height: 150))
        let lb = UIStackView()
        lb.translatesAutoresizingMaskIntoConstraints = false        
        lb.backgroundColor = UIColor(rgb: 0x161f28)
        return lb
    }()
    */
    
    var textFieldplaceName: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
//        let tf = UILabel(frame: CGRect(x: 0, y: 50, width: 200, height: 150))
        tf.text = "--"
        tf.textColor = .white
        tf.layer.cornerRadius = 15.0
        tf.layer.borderWidth = 2.0
        tf.layer.borderColor = UIColor.red.cgColor
        //tf.layoutMargins = 20
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        //tf.backgroundColor = UIColor(rgb: 0x161f28)
        return tf
    }()
    
    var specificLocation: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
//        let lb = UILabel(frame: CGRect(x: 0, y: 50, width: 200, height: 150))
        //lb.text = "Current Latitude:"
        lb.numberOfLines = 0
        lb.textColor = UIColorConstant.yellowColor
        lb.backgroundColor = UIColor(rgb: 0x161f28)
        return lb
    }()
    
    /*
    var currentLongitude: UILabel = {
        //let lb = UILabel()
        //lb.translatesAutoresizingMaskIntoConstraints = false
        let lb = UILabel(frame: CGRect(x: 50, y: 250, width: 200, height: 150))
        lb.text = "Current Latitude:"
        lb.textColor = UIColorConstant.yellowColor
        return lb
    }()
    */
    
    var buttonUpdatePlaceName: UIButton = {
        //let bt = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Update Place Name", for: .normal)
        bt.backgroundColor = UIColor(rgb: 0x3598db)
        return bt
    }()
    
    
    var buttonShowMapCoordinate: UIButton = {
        //let bt = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Show on Map", for: .normal)
        bt.backgroundColor = UIColor(rgb: 0x3598db)
        return bt
    }()
    
    var buttonDeleteCoordinate: UIButton = {
        //let bt = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Delete Coordinate", for: .normal)
        bt.backgroundColor = UIColor(rgb: 0x3598db)
        return bt
    }()
    
    
    let disposeBag = DisposeBag()
    //let latitudeString: BehaviorRelay = BehaviorRelay<String>(value: "")
    let locationData: BehaviorRelay = BehaviorRelay<CoordinateCellDataModel>(
        value: CoordinateCellDataModel(locationId: "", namePlace: "", latitude: 0, longitude: 0)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureRxComponents()
                
    }
    
    func configureViews() {
        self.title = "Location Details"
        
        self.view.addSubview(specificLocation)
            
        self.view.addSubview(buttonDeleteCoordinate)
        buttonDeleteCoordinate.addTarget(self, action: #selector(deleteCoordinateFunction), for: .touchUpInside)
        self.view.addSubview(buttonShowMapCoordinate)
        buttonShowMapCoordinate.addTarget(self, action: #selector(showMapCoordinateFunction), for: .touchUpInside)
        self.view.addSubview(buttonUpdatePlaceName)
        buttonUpdatePlaceName.addTarget(self, action: #selector(updatePlaceNameFunction), for: .touchUpInside)
        
        self.view.addSubview(textFieldplaceName)
    }
    
    func configureRxComponents() {
        locationData.map({
            locationDataObject in
            print("locationDataObject: \(locationDataObject)")
            return """
                Latitude:
                \(locationDataObject.latitude)
                
                Longitude:
                \(locationDataObject.longitude)
            """
        })
            .bind(to: specificLocation.rx.text)
        .disposed(by: disposeBag)
        
        locationData.map({
            locationDataObject in
            return locationDataObject.namePlace
        })
            .bind(to: textFieldplaceName.rx.text)
        .disposed(by: disposeBag)
        
        //latitudeString.bind(to: currentLatitude.rx.text)
        //.disposed(by: disposeBag)
    }
    
    
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setContrainsts()
    }
    
    @objc func deleteCoordinateFunction() {
        print("deleteCoordinateFunction")
        
        locationData.subscribe(onNext: {
            [weak self] locationDataObject in
            print("name: \(locationDataObject.locationId)")
            LocationDAO().deleteRealmSpecificObjectById(locationDataObject.locationId)
            self?.navigationController?.popViewController(animated: true)
        })
        .disposed(by: disposeBag)
                
    }
    
    @objc func updatePlaceNameFunction() {
        print("updatePlaceNameFunction")        
        locationData.subscribe(onNext: {
            [weak self] locationDataObject in
            print("name: \(locationDataObject.locationId)")
            LocationDAO().updateRealmSpecificObjectById(
                locationDataObject.locationId,
                self?.textFieldplaceName.text ?? "")
            self?.navigationController?.popViewController(animated: true)
        })
        .disposed(by: disposeBag)
        
    }
    
    @objc func showMapCoordinateFunction() {
        print("show map")
        locationData.subscribe(onNext: {
            locationDataObject in
            let url = "https://maps.google.com/?q=\(locationDataObject.latitude),\(locationDataObject.longitude)"
            print("url: \(url)")
            UIApplication.shared.open( URL(string: url)! )
        })
        .disposed(by: disposeBag)
        
    }
    
    func setContrainsts() {
        
        textFieldplaceName.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        textFieldplaceName.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textFieldplaceName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        specificLocation.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        specificLocation.heightAnchor.constraint(equalToConstant: 250).isActive = true
        specificLocation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
               
        buttonUpdatePlaceName.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        buttonUpdatePlaceName.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonUpdatePlaceName.bottomAnchor.constraint(equalTo: buttonShowMapCoordinate.topAnchor, constant: -10).isActive = true
        
        buttonShowMapCoordinate.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        buttonShowMapCoordinate.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonShowMapCoordinate.bottomAnchor.constraint(equalTo: buttonDeleteCoordinate.topAnchor, constant: -10).isActive = true
        
        buttonDeleteCoordinate.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        buttonDeleteCoordinate.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonDeleteCoordinate.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
    }
}
