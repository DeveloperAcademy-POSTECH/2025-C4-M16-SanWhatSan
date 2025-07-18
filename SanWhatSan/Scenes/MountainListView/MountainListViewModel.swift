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
    let manager = MountainManager.shared
    
    @Published var selectedMountain: Mountain?
    
    @Published var userLocation: CLLocation?
    @Published var closestMountains: [Mountain] = []
    @Published var shouldShowAlert = false
    
    private var lastUpdateLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        manager.$chosenMountain
            .receive(on: DispatchQueue.main)
            .assign(to: &$selectedMountain)
    }

    func requestLocationAccess() {
        let status = locationManager.authorizationStatus
        handleAuthStatus(status)
    }

    private func handleAuthStatus(_ status: CLAuthorizationStatus) {
        print("권한 상태: \(status.rawValue)")
        DispatchQueue.main.async { self.shouldShowAlert = false }

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            DispatchQueue.main.async { self.shouldShowAlert = true }
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

    private func updateClosestMountains(from location: CLLocation) {
        if let last = lastUpdateLocation,
           closestMountains.isEmpty,
           location.distance(from: last) < 50 { // 50미터 이하 변화라면 무시
            print("거리 계산 생략")
            return
        }

        lastUpdateLocation = location
        print("거리 계산 시작")

        self.closestMountains = manager.getClosestMountains(from: location)
        locationManager.stopUpdatingLocation()
    }
}



