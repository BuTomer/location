//
//  LandmarkAnnotation.swift
//  LocaGit
//
//  Created by Tomer Buzaglo 
//  
//


class LandmarkAnnotation: Annotation{
    let landmark: Landmark
    
    init(landmark: Landmark){
        self.landmark = landmark
        
        super.init(
            coordinate: landmark.coordinate,
            title: landmark.name,
            subtitle: landmark.vendorName
        )
    }
}
