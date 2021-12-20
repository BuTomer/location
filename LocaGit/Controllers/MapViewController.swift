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
            let annotations = landmarks.map(LandmarkAnnotation.init)
            mapView.addAnnotations(annotations)
            mapView.fit(annotations: annotations)
        }
    }
    
    //lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
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

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation =
                annotation as? LandmarkAnnotation else {return nil}
        var annotationView =
        mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") as? MKMarkerAnnotationView
        
        if annotationView == nil{
            annotationView = MKMarkerAnnotationView(
                annotation: annotation, reuseIdentifier: "annotation")
        }else{
            print("reuse") //scroll away from the country and come back
        }
        
        annotationView?.markerTintColor = annotation.landmark.color
        annotationView?.canShowCallout = true
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? LandmarkAnnotation else {return}
        print(annotation.landmark.name)
        print("Your location is: \(LocationManager.shared.location)")
    }
    
}

extension MKMapView {

    func fit(annotations: [MKAnnotation], with padding: CGFloat = 50) {
        //null since we need the 1st point for the initial rect
        var zoomRect: MKMapRect = .null
        annotations.map{MKMapPoint($0.coordinate)}.forEach({
            let rect = MKMapRect(x: $0.x, y: $0.y, width: 0.1, height: 0.1)
            zoomRect = zoomRect.isNull ? rect : zoomRect.union(rect)
        })

        let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        setVisibleMapRect(zoomRect, edgePadding: insets, animated: true)
    }
}
