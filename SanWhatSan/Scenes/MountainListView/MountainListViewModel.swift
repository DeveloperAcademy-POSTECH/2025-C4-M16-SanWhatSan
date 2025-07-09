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
        print("거리 계산 시작")
        let sorted = mountains.sorted {
            let d1 = CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude).distance(from: location)
            let d2 = CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude).distance(from: location)
            
            return d1 < d2
        }
        print("가장 가까운 산: \(sorted.first?.name ?? "없음")")
        self.closestMountains = sorted
    }
}


