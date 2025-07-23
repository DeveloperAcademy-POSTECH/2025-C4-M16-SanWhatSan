//
//  MountainManager.swift
//  SanWhatSan
//
//  Created by 박난 on 7/17/25.
//

import CoreLocation

import Foundation
import CoreLocation
import MapKit

final class MountainManager: ObservableObject {
    
    static let shared = MountainManager()
    @Published private(set) var mountains: [Mountain] = []
    private(set) var mountainNames: [String] = []    // 산 이름만
    
    @Published var chosenMountain: Mountain?

    private init() {
//        self.mountains = [
//            
//            //TODO: 추후 삭제
//            Mountain(name: "운제산", description: "경북", coordinate: Coordinate(latitude: 35.8401, longitude: 128.5554), distance: 100, summitMarkerCount: 1),
//            Mountain(name: "도음산", description: "경북", coordinate: Coordinate(latitude: 35.8725, longitude: 128.6021), distance: 100, summitMarkerCount: 1),
//            Mountain(name: "봉좌산", description: "경북", coordinate: Coordinate(latitude: 35.8602, longitude: 128.5703), distance: 100, summitMarkerCount: 1)
//        ]
        self.mountainNames = [
            "운제산", "도음산", "봉좌산"
        ]
    
    }
    
    // MARK: -산 이름으로 위경도 검색해서 배열로 반환, 상한선도 여기서 조절 가능 (기본) 
    func searchMountains (names: [String], regionCenter: CLLocationCoordinate2D, radius: CLLocationDistance){
        mountains.removeAll()
        let group = DispatchGroup()
        var found: [Mountain] = [] // 모아놨다가 한번에 넣으려고..
        print("searchMountains 실행")
        
        for name in names {
            group.enter()
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = name
            request.region = MKCoordinateRegion(center: regionCenter, latitudinalMeters: radius, longitudinalMeters: radius)
            
            MKLocalSearch(request: request).start { response, error in
                defer { group.leave() }
                guard let items = response?.mapItems, error == nil else { return }
                let namedMountains = items.filter { item in
                    item.name?.hasSuffix("산") ?? false
                }
                
                let results: [Mountain] = namedMountains.map { item in
                    let placemark = item.placemark
                    // 주소 컴포넌트
                    let street = placemark.thoroughfare ?? ""
                    let city   = placemark.locality ?? ""
                    let admin  = placemark.administrativeArea ?? ""
                    
                    let address = [admin, city, street]
                        .filter { !$0.isEmpty }
                        .joined(separator: " ")
                    
                    let coord = placemark.coordinate
                    return Mountain(
                        name: item.name ?? "산",
                        description: address,
                        coordinate: Coordinate(
                            latitude: coord.latitude,
                            longitude: coord.longitude
                        ),
                        distance: 0,
                        summitMarkerCount: 1
                    )
                }
                
                DispatchQueue.main.async{
                    found.append(contentsOf: results)
                    //print("최종 Mountains: \(results)")
                }
            }
        }
        group.notify(queue: .main) { //없으면 비동기함수가 끝나기 전에 할당해서 mountains 계속 비어있음
            self.mountains = found
            print("🔍 진짜 검색 완료: \(self.mountains.map(\.name))")
        }
        
    }
    
    func getClosestMountains(from location: CLLocation, within radius: Double = 50_000) -> [Mountain] {
        return mountains.compactMap { mountain in
            let distance = CLLocation(
                latitude: mountain.coordinate.latitude,
                longitude: mountain.coordinate.longitude
            ).distance(from: location)
            guard distance <= radius else { return nil }
            var m = mountain
            m.distance = Int(distance)
            return m
        }
        .sorted { $0.distance < $1.distance }
    }

    func distance(from location: CLLocation, to mountain: Mountain) -> CLLocationDistance {
        CLLocation(
            latitude: mountain.coordinate.latitude,
            longitude: mountain.coordinate.longitude
        ).distance(from: location)
    }
}

