//
//  Landmark+extensions.swift
//  LocaGit
//
//  Created by Tomer Buzaglo 
//  
//


import UIKit
import CoreLocation

extension Landmark{
    var coordinate: CLLocationCoordinate2D{
        .init(latitude: y, longitude: x)
    }
    
    var location: CLLocation{
        .init(latitude: y, longitude: x)
    }
    
    enum Types: String, CaseIterable{
        case han = "חאן"
        case campSchool = "מרכז שדה"
        case nationalPark = "גן לאומי"
        case nightCamp = "חניון לילה"
        case other = "קמפינג"
        
        static func type(for name:String)-> Types{
            for t in Types.allCases{
                if name.contains(t.rawValue){
                    return t
                }
            }
            return .other
        }
    }
    
    var type: Types{
        Types.type(for: self.name)
    }
    
    var color: UIColor{
        switch self.type{
        case .campSchool:
            return .blue
        case .nationalPark:
            return .orange
        case .han:
            return .black
        case .nightCamp:
            return .systemMint
        case .other:
            return .red
        }
    }
}
