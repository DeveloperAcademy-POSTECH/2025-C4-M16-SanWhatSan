//
//  MountainManager.swift
//  SanWhatSan
//
//  Created by 박난 on 7/17/25.
//

import CoreLocation

import Foundation
import CoreLocation

final class MountainManager: ObservableObject {
    
    static let shared = MountainManager()
    private(set) var mountains: [Mountain] = []
    
    @Published var chosenMountain: Mountain?

    private init() {
        self.mountains = [
            Mountain(name: "운제산", description: "경북", coordinate: Coordinate(latitude: 35.8401, longitude: 128.5554)),
            Mountain(name: "도음산", description: "경북", coordinate: Coordinate(latitude: 35.8725, longitude: 128.6021)),
            Mountain(name: "봉좌산", description: "경북", coordinate: Coordinate(latitude: 35.8602, longitude: 128.5703))
        ]
    }

    func getClosestMountains(from location: CLLocation, within radius: Double = 100_000) -> [Mountain] {
        mountains.compactMap { mountain in
            let distance = CLLocation(
                latitude: mountain.coordinate.latitude,
                longitude: mountain.coordinate.longitude
            ).distance(from: location)

            return distance <= radius ? (mountain, distance) : nil
        }
        .sorted { $0.1 < $1.1 }
        .map { $0.0 }
    }

    func distance(from location: CLLocation, to mountain: Mountain) -> CLLocationDistance {
        CLLocation(
            latitude: mountain.coordinate.latitude,
            longitude: mountain.coordinate.longitude
        ).distance(from: location)
    }
}

