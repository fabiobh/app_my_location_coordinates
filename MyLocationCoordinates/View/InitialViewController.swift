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
    
    
    let statusString: BehaviorRelay = BehaviorRelay<String>(value: "")
        
    let disposeBag = DisposeBag()
    let locationViewModel = LocationViewModel()
        
    var countLocationLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        //let lb = UILabel(frame: CGRect(x: 100, y: 250, width: 100, height: 50))
        lb.numberOfLines = 1
        lb.textColor = UIColorConstant.yellowColor
        lb.backgroundColor = UIColor(rgb: 0x161f28)
        return lb
    }()
    
    var currentStatusLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        //let lb = UILabel(frame: CGRect(x: 100, y: 250, width: 100, height: 50))
        lb.numberOfLines = 0
        lb.textColor = UIColorConstant.yellowColor
        lb.backgroundColor = UIColor(rgb: 0x161f28)
        return lb
    }()
    
    var buttonSaveCoordinate: UIButton = {
        //let bt = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setTitle("Start GPS", for: .normal)
        bt.backgroundColor = UIColor(rgb: 0x3598db)
        
        return bt
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .plain)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tb.separatorColor = .red
        tb.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        return tb
    }()
    
    /*
    var detailsStackView: UIStackView = {
        let lb = UIStackView()
        lb.translatesAutoresizingMaskIntoConstraints = false
        //let lb = UIStackView(frame: CGRect(x: 100, y: 50, width: 200, height: 150))
        lb.backgroundColor = UIColor(rgb: 0x161f28)
        return lb
    }()
    */
    
    /*
    var bottomView: UIView = {
        //let v = UIView(frame: CGRect(x: 100, y: 250, width: 100, height: 50))
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(rgb: 0x161f28)
        return v
    }()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //debug()
        configureViews()
        configureRxComponents()
        getLocation()
        //checkGpsIsActive()
    }
    
    
    
    func debug() {
        print("NSHomeDirectory: \(NSHomeDirectory())")
    }
    
    func configureViews() {
        
        //self.view.backgroundColor = UIColor(rgb: 0x2d3e50)
        self.title = "Locations Recorded"
        
        self.view.addSubview(tableView)
        //self.view.addSubview(bottomView)
        //self.view.addSubview(detailsStackView)
        
        self.view.addSubview(buttonSaveCoordinate)
        buttonSaveCoordinate.addTarget(self, action: #selector(saveCoordinate), for: .touchUpInside)
        
        self.view.addSubview(currentStatusLabel)
        self.view.addSubview(countLocationLabel)
        
    }
    
    func configureRxComponents() {
        
        myCurrentStatusValue.bind(to: currentStatusLabel.rx.text)
        .disposed(by: disposeBag)
        
        locationViewModel.myCountLocationValue.bind(to: countLocationLabel.rx.text)
            .disposed(by: disposeBag)
        
        locationViewModel.tableViewItems
            .bind(to: tableView
                .rx
                .items(cellIdentifier: CustomTableViewCell.identifier, cellType: CustomTableViewCell.self)
            ) {
                (tv, tableViewItem, cell) in
                //cell.textLabel?.text = "\(tableViewItem.latitude) | \(tableViewItem.longitude)"
                cell.label1.text = "\(tableViewItem.namePlace)"
                cell.label2.text = "\(tableViewItem.latitude) | \(tableViewItem.longitude)"
            }
        .disposed(by: disposeBag)
                    
        tableView
            .rx.modelSelected(CoordinateCellDataModel.self)
            .subscribe(onNext: {
                [weak self] coordinateObject in
                print("x: \(coordinateObject.namePlace)")
                let vc = LocationDetailViewController()
                vc.locationData.accept(
                    CoordinateCellDataModel(locationId: coordinateObject.locationId, namePlace: coordinateObject.namePlace, latitude: coordinateObject.latitude, longitude: coordinateObject.longitude)
                )
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        .disposed(by: disposeBag)
        
        tableView
          .rx.setDelegate(self)
          .disposed(by: disposeBag)
                
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }
    
    func setConstraints() {
        //tableView.frame = view.bounds
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: countLocationLabel.topAnchor, constant: 0).isActive = true
        
        countLocationLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        countLocationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        countLocationLabel.bottomAnchor.constraint(equalTo: currentStatusLabel.topAnchor, constant: 0).isActive = true
        
        currentStatusLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        currentStatusLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        currentStatusLabel.bottomAnchor.constraint(equalTo: buttonSaveCoordinate.topAnchor, constant: 0).isActive = true
        
        buttonSaveCoordinate.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        buttonSaveCoordinate.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonSaveCoordinate.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
        
    
    
    func saveDataAndUpdateScreen() {
        LocationDAO().saveRealmData(latitude: myCurrentLatitude.value, longitude: myCurrentLongitude.value)
        locationViewModel.getRealmDataToTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        locationViewModel.getRealmDataToTableView()
        
    }
    
    
    @objc func saveCoordinate() {
        
        print("myCurrentStatusValue.value: \(myCurrentStatusValue.value)")
        if myCurrentStatusValue.value == "" {
            print("startLocation")
            getLocation()
        } else {
            print("save coordinate")
            saveDataAndUpdateScreen()
        }
        buttonSaveCoordinate.setTitle("Save Coordinate", for: .normal)
        
    }

}

extension InitialViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //guard section == 2 else { return nil }
        //let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 40)
        let lb = UILabel() // UILabel(frame: frame)
        lb.backgroundColor = .gray
        lb.text = "    Latitude | Longitude"
        return lb
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
