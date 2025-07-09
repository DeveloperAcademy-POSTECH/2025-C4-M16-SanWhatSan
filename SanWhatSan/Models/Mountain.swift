//
//  Mountain.swift
//  SanWhatSan
//
//  Created by Zhen on 7/8/25.
//

import Foundation
import MapKit

struct Mountain: Identifiable, Equatable {
    
    let id = UUID()
    let name: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    
    
    //Equatable 을 위한 비교.. 근데 그냥 위경도로만 비교함.. id로만 비교해도 되긴 함.
    static func == (lhs: Mountain, rhs: Mountain) -> Bool {
            lhs.coordinate.latitude == rhs.coordinate.latitude &&
            lhs.coordinate.longitude == rhs.coordinate.longitude
        }
}
