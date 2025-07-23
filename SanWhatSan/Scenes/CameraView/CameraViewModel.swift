//
//  CameraViewModel.swift
//  SanWhatSan
//
//  Created by 박난 on 7/10/25.
//

import SwiftUI
import CoreLocation

class CameraViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    let manager = MountainManager.shared
    
    @Published var selectedMountain: Mountain?
    @Published var userLocation: CLLocation?
    @Published var shouldShowAlert = false

    private var lastUpdateLocation: CLLocation?
    let arManager = ARManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //requestLocationAccess()
        manager.$chosenMountain
            .receive(on: DispatchQueue.main)
            .assign(to: &$selectedMountain)
    }

    func startARSession() {
        arManager.startSession()
    }

    func handleTap(at point: CGPoint) {
        arManager.placeModel(at: point)
        print("placeModel")
    }

    // MARK: 권한 요청은 LocationService 로 이동, 앱 시작점에서 한 번만 요청
    // MARK: - 위치 권한 요청
//    private func requestLocationAccess() {
//        let status = locationManager.authorizationStatus
//        handleAuthStatus(status)
//    }
//
//    private func handleAuthStatus(_ status: CLAuthorizationStatus) {
//        DispatchQueue.main.async { self.shouldShowAlert = false }
//
//        switch status {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .restricted, .denied:
//            DispatchQueue.main.async { self.shouldShowAlert = true }
//        case .authorizedAlways, .authorizedWhenInUse:
//            locationManager.startUpdatingLocation()
//        default:
//            break
//        }
//    }
//
//    // MARK: - CLLocationManagerDelegate
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        handleAuthStatus(manager.authorizationStatus)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let currentLocation = locations.last else { return }
//        print("위치 갱신됨: \(currentLocation)")
//
//        DispatchQueue.main.async {
//            self.userLocation = currentLocation
//            self.updateClosestMountain(from: currentLocation)
//        }
//    }

    private func updateClosestMountain(from location: CLLocation) {
        if let last = lastUpdateLocation,
           location.distance(from: last) < 50 {
            print("거리 계산 생략")
            return
        }

        lastUpdateLocation = location
        print("거리 계산 시작")

        if let nearest = manager.getClosestMountains(from: location).first {
            manager.chosenMountain = nearest
            print("선택된 산: \(nearest.name)")
        }

        locationManager.stopUpdatingLocation()
    }
}
