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

class InitialViewController: UIViewController {
    
    let realm = try! Realm()
    let disposeBag = DisposeBag()
        
    //var data = [String]()
    var tableViewItems = Observable.just(["aaa","bbb","ccc"])
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .plain)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.isScrollEnabled = true
        tb.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        //tb.delegate = self
        //tb.dataSource = self
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for x in 0...100 {
//            data.append("Some data \(x)")
//        }
        self.title = "Locations Recorded"
        self.view.addSubview(tableView)
        
        tableViewItems
            .bind(to: tableView
                .rx
                .items(cellIdentifier: CustomTableViewCell.identifier, cellType: CustomTableViewCell.self)
            ) {
                    (tv, tableViewItem, cell) in
                cell.lab
                    cell.textLabel?.text = tableViewItem
            }
            .disposed(by: disposeBag)
        
        
        //self.view.backgroundColor = .blue
        
        //saveDataRealm()
        //render()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func deleteDataRealm() {
        realm.beginWrite()
        realm.delete(realm.objects(LocationData.self))
        try! realm.commitWrite()
    }
    
    func saveDataRealm() {
        let myLocation = LocationData(placeName: UUID().uuidString, latitude: 1, longitude: 1)
        realm.beginWrite()
        realm.add(myLocation)
        try! realm.commitWrite()
        print("data saved")
        
    }

    func render() {
        let locations = realm.objects(LocationData.self)
        print("locations count: \(locations.count)")
        dump(locations)
        
        for location in locations {
            let placeName = location.placeName
            let latitude = location.latitude
            let longitude = location.longitude
            print("placeName: \(placeName)")
            
            let label = UILabel(frame: view.bounds)
            label.text = placeName
            label.textAlignment = .center
            label.numberOfLines = 0
            view.addSubview(label)
        }
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
