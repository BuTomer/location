//
//  Landmarks.swift
//  LocaGit
//
//  Created by Tomer Buzaglo 
//  
//


import Combine
import CoreLocation
import UIKit
struct Landmarks{
    static func load()->  AnyPublisher<Array<Landmark>, Error>{
        guard let url = Bundle.main.url(forResource: "camp_il", withExtension: "json")
        else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                //can throw here
                return element.data
            }
            .decode(type: [Landmark].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
