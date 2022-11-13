//
//  CustomTableViewCell.swift
//  MyLocationCoordinates
//
//  Created by fabiocunha on 06/11/22.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    static let identifier = "myCell"
    /*
    let _switch: UISwitch = {
       let _switch = UISwitch()
        return _switch
    }()
    */
    
    let label1: UILabel = {
        let lb = UILabel()
        lb.text = "--"
        return lb
    }()
    
    let label2: UILabel = {
        let lb = UILabel()
        lb.text = "--"
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .orange
        //contentView.addSubview(_switch)
        contentView.addSubview(label1)
        contentView.addSubview(label2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        /*
        _switch.frame = CGRect(x: 5,
                               y: 5,
                               width: 100,
                               height: contentView.frame.size.height - 10)
        */
        label1.frame = CGRect(x: 20,
                               y: -10,
                              width: contentView.bounds.width,
                               height: contentView.frame.size.height - 10)
        label2.frame = CGRect(x: 20,
                               y: 10,
                               width: contentView.frame.size.width,
                               height: contentView.frame.size.height - 10)
        
    }
}
