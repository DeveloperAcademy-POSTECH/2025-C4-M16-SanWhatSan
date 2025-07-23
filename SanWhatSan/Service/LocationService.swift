//
//  LocationService.swift
//  SanWhatSan
//
//  Created by Zhen on 7/19/25.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    static let shared = LocationService()
    
    private var locationManager = CLLocationManager()
    
    @Published var selectedMountain: Mountain?
    @Published var userLocation: CLLocation?
    @Published var shouldShowAlert = false

    private var lastUpdateLocation: CLLocation?
    let arManager = ARManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationAccess()
    }


    // MARK: - 위치 권한 요청
    func requestLocationAccess() {
        let status = locationManager.authorizationStatus
        handleAuthStatus(status)
    }

    private func handleAuthStatus(_ status: CLAuthorizationStatus) {
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

    // MARK: - CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthStatus(manager.authorizationStatus)
    }
}
