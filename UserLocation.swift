//
//  UserLocation.swift
//  ChatHook
//
//  Created by Kevin Farm on 9/19/16.
//  Copyright © 2016 splashscene. All rights reserved.
//



import Foundation
import CoreLocation
import MapKit

class UserLocation: NSObject {
    
    let location: CLLocation
    let name: String
    let imageName: String
    
    init(latitude: Double, longitude: Double, name: String, imageName: String) {
        location = CLLocation(latitude: latitude, longitude: longitude)
        self.name = name
        self.imageName = imageName
    }
}

extension UserLocation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return location.coordinate
        }
    }
    var title: String? {
        get {
            return name
        }
    }
}
