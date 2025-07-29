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
    
    @Published var selectedMountain: Mountain?  //view 에서 선택된 산
    @Published var mountains: [Mountain] = []   //검색된 산들 (보통 Manager 에서 할당 받음)
    
    @Published var userLocation: CLLocation?    //사용자의 현재 위치 
    @Published var closestMountains: [Mountain] = []    //사용자 위치 기준 3km 이내 산들
    @Published var shouldShowAlert = false
    
    private var lastUpdateLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //chosenMountain 을 구독해서 selectedMountain 에 할당
        manager.$chosenMountain
            .receive(on: DispatchQueue.main)
            .assign(to: &$selectedMountain)
        
        // MountainListViewModle 의 Mountain 은 @Published로 외부에서 갱신되고 그걸 구독해야해서 필요함. - MountainManager
        manager.$mountains
            .receive(on: DispatchQueue.main)
            .assign(to: &$mountains)
        locationManager.startUpdatingLocation()
        
        //userLocation 이랑 mountains 중 하나라도 바뀌면 실행. 단, userLocation 은 optional 이기 때문에 nil이 아닐 때만 반응.
        Publishers
            .CombineLatest($userLocation.compactMap { $0 }, $mountains)
            .map { [weak self] loc, _ in
                //self?.manager.getClosestMountains(from: loc) ?? []
                let closest = self?.manager.getClosestMountains(from: loc) ?? []    // 내부에서 가장 가까운 산들을 가져옴. 여기서 loc 는 userLocation이고, _ 는 mountains 지만 여기서 사용 안함.
                                if let first = closest.first {  //산들 중 가장 가까운 산을 chosenMountain 에 할당.
                                    self?.manager.chosenMountain = first
                                }
                                return closest
            }
            .receive(on: DispatchQueue.main) //UI 관련 업데이트니까 메인스레드에서 실행
            .assign(to: &$closestMountains)  //closestMountains에 할당 -> 이거 뷰에서 바로 다시 그려짐
        
        MountainManager.shared.searchMountains(
            names: MountainManager.shared.mountainNames,
            regionCenter: CLLocationCoordinate2D(latitude: 36.0, longitude: 128.0),
            radius: 100_000
        )
    }
    
    //사용자의 위치가 바뀔때마다 호출되는 함수. 가장 최근 위치값 활용.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        print("위치 갱신됨: \(currentLocation)")
        
        self.manager.searchMountains(
            names: self.manager.mountainNames,
            regionCenter: currentLocation.coordinate,   //현재 위치를 중심으로 3km 주변 산 업데이트
            radius: 3_000
        )
        DispatchQueue.main.async {//메인스레드에서 userLocation으로 currentLocation 갱신, updateClosestMountains 함수 실행
            self.userLocation = currentLocation
            self.updateClosestMountains(from: currentLocation)
            print("locationManager userLocation update")
            //print(locations.last)
        }
        //locationManager.stopUpdatingLocation()
    }
    
    //userLocation이 바뀌었을 때 호출, 불필요한 거리 계산 무시 + closestMountains update, 위치 업데이트 멈춤.
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




