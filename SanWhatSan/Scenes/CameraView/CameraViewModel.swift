//
//  CameraViewModel.swift
//  SanWhatSan
//
//  Created by 박난 on 7/10/25.
//

import SwiftUI
import CoreLocation
import Combine

class CameraViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    let manager = MountainManager.shared
    
    @Published var selectedMountain: Mountain?
    @Published var userLocation: CLLocation?
    @Published var shouldShowAlert = false
    @Published var summitMarker: SummitMarker?

    private var lastUpdateLocation: CLLocation?
    var arManager = ARManager()
    private var cancellables = Set<AnyCancellable>()


    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        manager.$chosenMountain
            .receive(on: DispatchQueue.main)
            .assign(to: &$selectedMountain)
        
        $summitMarker
            .sink { [weak self] newMarker in
                self?.arManager.marker = newMarker
            }
            .store(in: &cancellables)
       
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
    
    func updateSummitMarker(for mountainName: String, isFallback: Bool = false) -> SummitMarker {
        switch mountainName{
        case "도음산":
            return SummitMarker(
                modelFileName: "sws1.usd",
                textureFileName: "normalDX.jpg",
                overlayFileName: "uv.jpg"
            )
        case "봉좌산":
            if isFallback {
                return SummitMarker(
                    modelFileName: "sws1.usd",
                    textureFileName: "normalDX.jpg",
                    overlayFileName: "uv.jpg"
                )
            } else {
                return SummitMarker(
                    modelFileName: "sws2.usd",
                    textureFileName: "normalDX2.jpg",
                    overlayFileName: "uv2.jpg")
            }
        default:
            return SummitMarker()
        }
    }
    
//    func updateARMarker(){
//        arManager.marker = summitMarker
//    }
        
}
