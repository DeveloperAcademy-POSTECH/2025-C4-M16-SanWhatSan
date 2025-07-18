//
//  Coordinate.swift
//  SanWhatSan
//
//  Created by 박난 on 7/17/25.
//

import Foundation
import CoreLocation

struct Coordinate: Hashable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    
    init(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.latitude = latitude
        self.longitude = longitude
    }

    var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
