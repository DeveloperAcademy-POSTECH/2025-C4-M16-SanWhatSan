//
//  Mountain.swift
//  SanWhatSan
//
//  Created by Zhen on 7/8/25.
//

import Foundation
import MapKit

struct Mountain: Identifiable, Hashable {
    
    let id = UUID()
    let name: String
    let description: String
    let coordinate: Coordinate
    
    var distance: Int
    let summitMarkerCount: Int
    
}

enum MountainName: String {
    case doeum = "도음산"
    case bongjoa = "봉좌산"
    case unjae = "운제산"
}
