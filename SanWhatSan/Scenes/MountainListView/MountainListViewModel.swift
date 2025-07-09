//
//  MountainListViewModel.swift
//  SanWhatSan
//
//  Created by Zhen on 7/8/25.
//

import Foundation
import MapKit

class MountainListViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    @Published var userLocation: CLLocation?
    @Published var closestMountains: [Mountain] = []
    @Published var shouldShowAlert = false
    
    private var lastUpdateLocation: CLLocation?
    
    //temp data
    private let mountains: [Mountain] = [
        Mountain(name: "운제산", description:"경북", coordinate: CLLocationCoordinate2D(latitude: 35.8401, longitude: 128.5554)),
           Mountain(name: "도음산", description:"경북", coordinate: CLLocationCoordinate2D(latitude: 35.8725, longitude: 128.6021)),
           Mountain(name: "봉좌산", description:"경북", coordinate: CLLocationCoordinate2D(latitude: 35.8602, longitude: 128.5703))
       ]
       
       override init() {
           super.init()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
       }
    
    func requestLocationAccess() {
        let status = locationManager.authorizationStatus
        handleAuthStatus(status)
    }
    
    private func handleAuthStatus(_ status: CLAuthorizationStatus){
        print("권한 상태: \(status.rawValue)")
        DispatchQueue.main.async {
            self.shouldShowAlert = false
        }
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            DispatchQueue.main.async {
                self.shouldShowAlert = true
            }
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthStatus(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        print("위치 갱신됨: \(currentLocation)")
        DispatchQueue.main.async {
            self.userLocation = currentLocation
            self.updateClosestMountains(from: currentLocation)
        }
    }
    
    //거리계산 !
    private func updateClosestMountains(from location: CLLocation){
        //여기 상한선
        // 위치가 거의 안 바뀌었고, 이미 비어 있다면 검사 생략
        if let last = lastUpdateLocation,
           closestMountains.isEmpty,
           location.distance(from: last) < 50 { // 50미터 이하 변화라면 무시
            print("거리 계산 생략")
            return
        }
        
        print(" 거리 계산 시작")
        
        lastUpdateLocation = location

        let filtered = mountains.compactMap { mountain -> (Mountain, CLLocationDistance)? in
            let distance = CLLocation(latitude: mountain.coordinate.latitude, longitude: mountain.coordinate.longitude)
                .distance(from: location)
            if distance <= 100000 { // 100km
                return (mountain, distance)
            } else {
                return nil
            }
        }
        .sorted { $0.1 < $1.1 }

        print("📍 10km 이내 산 목록: \(filtered.map { $0.0.name })")

        self.closestMountains = filtered.map { $0.0 }

        // 더 이상 위치 업데이트 받을 필요 없음
        self.locationManager.stopUpdatingLocation()

//        let sorted = mountains.sorted {
//            let d1 = CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude).distance(from: location)
//            let d2 = CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude).distance(from: location)
//            
//            return d1 < d2
//        }
//        print("가장 가까운 산: \(sorted.first?.name ?? "없음")")
//        self.closestMountains = sorted
    }
}


