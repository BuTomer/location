//
//  PlaceDetailsViewController.swift
//  LocaGit
//
//  Created by Tomer Buzaglo 
//  
//


import UIKit
import SafariServices

class PlaceDetailsViewController: UIViewController {
    
    @IBOutlet weak var circleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var landmark: Landmark?
    
    //lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        circleLabel.textColor = .white
        circleLabel.backgroundColor = landmark?.color
        circleLabel.text = landmark?.type.rawValue
        
        nameLabel.text = landmark?.name
    }
    
    //actions:
    @IBAction func website(_ sender: UIButton) {
        
        guard let url = URL(string: landmark?.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        else {return}
        
        let sfVC = SFSafariViewController(url: url)
        navigationController?.pushViewController(sfVC, animated: true)
    }
    
    @IBAction func navigate(_ sender: UIButton) {
        guard let coord = landmark?.coordinate,
              let url = URL(string: "http://maps.apple.com/?daddr=\(coord.latitude),\(coord.longitude)")
        else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
}
