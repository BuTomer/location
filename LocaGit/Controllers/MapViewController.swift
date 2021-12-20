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
            print(landmarks)
        }
    }

    //lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        Landmarks.load()
            .receive(on: DispatchQueue.main)
            .sink { completion in
            print(completion)
        } receiveValue: { landmarks in
            self.landmarks = landmarks
        }.store(in: &subscriptions)
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

