//
//  MapViewController.swift
//  LocaGit another git demo.
//
//  Created by Tomer Buzaglo 
//  
//


import UIKit
import MapKit
import Combine

class MapViewController: UIViewController {
    //props:
    @IBOutlet weak var mapView: MKMapView!
    var subscriptions: Set<AnyCancellable> = []
    var landmarks = [Landmark](){
        didSet{
            landmarks.forEach {
                let annotation = MKPointAnnotation()
                annotation.coordinate = $0.coordinate
                annotation.title = $0.name
                annotation.subtitle = $0.vendorName
                mapView.addAnnotation(annotation)
            }
        }
    }

    //lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLandmarks()
        observeAuth()
        
        mapView.showsUserLocation = LocationManager.shared.isAuthorized
    }

    //actions:
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            fatalError()
        }
    }
}

//Helpers:
extension MapViewController{
    fileprivate func observeAuth() {
        NotificationCenter.default.publisher(for: .Authorized, object: nil)
            .subscribe(on: DispatchQueue.main, options: nil)
            .sink {[weak self] notification in
                self?.mapView.showsUserLocation = true
            }
            .store(in: &subscriptions)
    }
    
    fileprivate func fetchLandmarks() {
        Landmarks.load()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { landmarks in
                self.landmarks = landmarks
            }.store(in: &subscriptions)
    }
}
