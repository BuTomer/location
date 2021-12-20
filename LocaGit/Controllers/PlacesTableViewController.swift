//
//  PlacesTableViewController.swift
//  LocaGit
//
//  Created by Tomer Buzaglo 
//  
//


import UIKit
import Combine

class PlacesTableViewController: UITableViewController {
    var landmarks: [Landmark] = []
    var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLandmarks()
    }

    // MARK: - Table view data source
 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        landmarks.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        if let cell = cell as? PlaceTableViewCell{
            cell.populate(with: landmarks[indexPath.row])
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "details", sender: landmarks[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let dest = segue.destination as? PlaceDetailsViewController,
            let landmark = sender as? Landmark else {
            return
        }

        dest.landmark = landmark
    }
}

//helpers:
extension PlacesTableViewController{
    fileprivate func fetchLandmarks() {
        Landmarks.load().receive(on: DispatchQueue.main)
            .sink { completion in
                print("done")
            } receiveValue: {[weak self] landmarks in
                self?.landmarks = landmarks
                self?.tableView.reloadData()
            }.store(in: &subscriptions)
    }
}
