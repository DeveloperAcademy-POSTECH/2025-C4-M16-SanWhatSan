//
//  MountainListViewModel.swift
//  SanWhatSan
//
//  Created by Zhen on 7/8/25.
//

import Foundation
import MapKit
import Combine

class MountainListViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    let manager = MountainManager.shared
    
    @Published var selectedMountain: Mountain?
    @Published var mountains: [Mountain] = []
    
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
        
        manager .$mountains
            .receive(on: DispatchQueue.main)
            .assign(to: &$mountains)
        locationManager.startUpdatingLocation()
        
        Publishers
            .CombineLatest($userLocation.compactMap { $0 }, $mountains)
            .map { [weak self] loc, _ in
                self?.manager.getClosestMountains(from: loc) ?? []
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$closestMountains)
        
        MountainManager.shared.searchMountains(
            names: MountainManager.shared.mountainNames,
            regionCenter: CLLocationCoordinate2D(latitude: 36.0, longitude: 128.0),
            radius: 100_000
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        print("위치 갱신됨: \(currentLocation)")
        
        self.manager.searchMountains(
            names: self.manager.mountainNames,
            regionCenter: currentLocation.coordinate,
            radius: 50_000
        )
        DispatchQueue.main.async {
            self.userLocation = currentLocation
            self.updateClosestMountains(from: currentLocation)
            print("locationManager userLocation update")
            //print(locations.last)
        }
        //locationManager.stopUpdatingLocation()
    }
    
    private func updateClosestMountains(from location: CLLocation) {
        print("updateClosestMountains 실행")
        if let last = lastUpdateLocation,
           closestMountains.isEmpty,
           location.distance(from: last) < 50 { // 50미터 이하 변화라면 무시
            //print("거리 계산 생략")
            locationManager.stopUpdatingLocation()
            
            return
        }
        
        lastUpdateLocation = location
        self.closestMountains = manager.getClosestMountains(from: location)
        locationManager.stopUpdatingLocation()
    }

}




