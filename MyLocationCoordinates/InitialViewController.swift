//
//  ViewController.swift
//  MyLocationCoordinates
//
//  Created by fabiocunha on 04/11/22.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class InitialViewController: LocationViewController {
    
    let realm = try! Realm()
    let disposeBag = DisposeBag()
    
    var tableViewItems = BehaviorRelay.init(value:
        [
            CoordinateCellDataModel(locationId: "", namePlace: "---", latitude: 1, longitude: 1),
            //CoordinateCellDataModel(namePlace: "bbb", latitude: 2, longitude: 2),
            //CoordinateCellDataModel(namePlace: "ccc", latitude: 3, longitude: 3)
        ]
    )
    
    var detailsStackView: UIStackView = {
        let lb = UIStackView()
        lb.translatesAutoresizingMaskIntoConstraints = false
        //let lb = UIStackView(frame: CGRect(x: 100, y: 50, width: 200, height: 150))
        lb.backgroundColor = UIColor(rgb: 0x161f28)
        return lb
    }()
    
    var currentLatitude: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        //let lb = UILabel(frame: CGRect(x: 100, y: 250, width: 100, height: 50))
        lb.text = "Current Latitude:"
        lb.textColor = UIColorConstant.yellowColor
        return lb
    }()
    
    var buttonSaveCoordinate: UIButton = {
        //let bt = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Save Coordinate", for: .normal)
        bt.backgroundColor = UIColor(rgb: 0x3598db)
        
        return bt
    }()
    
    var bottomView: UIView = {
        //let v = UIView(frame: CGRect(x: 100, y: 250, width: 100, height: 50))
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(rgb: 0x161f28)
        return v
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .plain)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //debug()
        configure()
        configRxComponents()
        getRealmDataToTableView()
    }
    
    func debug() {
        print("NSHomeDirectory: \(NSHomeDirectory())")
    }
    
    func configure() {
        
        self.view.backgroundColor = UIColor(rgb: 0x2d3e50)
        self.title = "Locations Recorded"
        
        self.view.addSubview(tableView)
        //self.view.addSubview(bottomView)
        self.view.addSubview(detailsStackView)
        
        self.view.addSubview(buttonSaveCoordinate)
        buttonSaveCoordinate.addTarget(self, action: #selector(saveCoordinate), for: .touchUpInside)
        
        self.view.addSubview(currentLatitude)
        
        
        
        
    }
    
    func configRxComponents() {
        tableViewItems
            .bind(to: tableView
                .rx
                .items(cellIdentifier: CustomTableViewCell.identifier, cellType: CustomTableViewCell.self)
            ) {
                (tv, tableViewItem, cell) in
                cell.label1.text = "z: \(tableViewItem.namePlace) zzz"
                //cell.textLabel?.text = tableViewItem
            }
        .disposed(by: disposeBag)
                    
        tableView
            .rx.modelSelected(CoordinateCellDataModel.self)
            .subscribe(onNext: {
                coordinateObject in
                print("x: \(coordinateObject.namePlace)")
                let vc = LocationDetailViewController()
                vc.latitudeString.accept(coordinateObject.namePlace)
                vc.locationData.accept(
                    CoordinateCellDataModel(locationId: coordinateObject.locationId, namePlace: coordinateObject.namePlace, latitude: 222, longitude: 333)
                )
                self.navigationController?.pushViewController(vc, animated: true)
            })
        .disposed(by: disposeBag)
                
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }
    
    func setConstraints() {
        tableView.frame = view.bounds
        
        buttonSaveCoordinate.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        buttonSaveCoordinate.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonSaveCoordinate.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
                
        detailsStackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        detailsStackView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        detailsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        currentLatitude.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        currentLatitude.heightAnchor.constraint(equalToConstant: 50).isActive = true
        currentLatitude.topAnchor.constraint(equalTo: detailsStackView.topAnchor, constant: 0).isActive = true
        
    }
    
    func deleteDataRealm() {
        realm.beginWrite()
        realm.delete(realm.objects(LocationData.self))
        try! realm.commitWrite()
    }
    
    func saveRealmData() {
        let myLocation = LocationData(placeName: UUID().uuidString, latitude: 1, longitude: 1)
        realm.beginWrite()
        realm.add(myLocation)
        try! realm.commitWrite()
        print("data saved")
                
    }
    
    func saveDataAndUpdateScreen() {
        saveRealmData()
        getRealmDataToTableView()
    }

    func getRealmDataToTableView() {
        
        let locations = realm.objects(LocationData.self)
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    
    
    
    @objc func saveCoordinate() {
        print("save coordinate")
        saveDataAndUpdateScreen()
    }


}

/*
extension InitialViewController:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = "Cell \(data[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell \(indexPath.row)")
    }
}
*/
