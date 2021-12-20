//
//  LocationManager.swift
//  LocaGit
//
//  Created by Tomer Buzaglo 
//  
//


import CoreLocation

class LocationManager: NSObject{
    //props:
    private let clm = CLLocationManager()
    
    //static props:
    static let shared = LocationManager()
    
    //computed props:
    var isAuthorized: Bool{
        clm.authorizationStatus == .authorizedAlways ||
        clm.authorizationStatus == .authorizedWhenInUse
    }
    
    var location: CLLocation?{
        clm.location
    }
    
    override init() {
        super.init()
        clm.delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            clm.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("No Permission")
        case .authorizedAlways, .authorizedWhenInUse:
            print("We have permission")
            NotificationCenter.default.post(name: .Authorized, object: nil)
        default:
            print("Unknown status")
            break
        }
    }
}

extension Notification.Name{
    static let Authorized: Notification.Name = .init(rawValue: "authorized")
    static let LocationChanged: Notification.Name = .init(rawValue: "changed")
}
