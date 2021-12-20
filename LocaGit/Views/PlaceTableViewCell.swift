//
//  PlaceTableViewCell.swift
//  LocaGit
//
//  Created by Tomer Buzaglo 
//  
//


import UIKit

class PlaceTableViewCell: UITableViewCell {
    @IBOutlet weak var circleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func populate(with landmark: Landmark){
        circleLabel.text = landmark.type.rawValue
        
        circleLabel.layer.cornerRadius =
        circleLabel.frame.height / 2
        
        circleLabel.layer.masksToBounds = true
        circleLabel.backgroundColor = landmark.color
        circleLabel.textColor = .white
        
        nameLabel.text = landmark.name
        subtitleLabel.text = landmark.vendorName
        
        
    }
}
