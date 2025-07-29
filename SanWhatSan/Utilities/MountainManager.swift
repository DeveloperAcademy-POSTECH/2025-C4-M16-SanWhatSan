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
    @Published private(set) var mountains: [Mountain] = []  //전역으로 공유되는 산 배열 
    private(set) var mountainNames: [String] = []    // 검색 대상이 들어갈 산 배열
    
    @Published var chosenMountain: Mountain?    //앱 전체적으로 사용되는 선택된 산

    private init() {
        self.mountainNames = [
            "운제산", "도음산", "봉좌산"
        ]
    
    }
    
    // MARK: -산 이름으로 위경도 검색해서 배열로 반환, 상한선도 여기서 조절 가능 (기본)
    // MKLocalSearch, DispatchGroup 활용
    func searchMountains (names: [String], regionCenter: CLLocationCoordinate2D, radius: CLLocationDistance){
        mountains.removeAll()   //일단 초기화
        let group = DispatchGroup()
        var found: [Mountain] = [] // 비동기요청 여러개 모아놨다가 한번에 넣으려고..
        print("searchMountains 실행")
        
        for name in names {
            group.enter()
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = name //산 이름은 자연어로 검색
            request.region = MKCoordinateRegion(center: regionCenter, latitudinalMeters: radius, longitudinalMeters: radius)    //지정된 반경 안에서 검색
            
            //여기서 Mountain 객체 만들어서 Mountains 에 할당함 !
            MKLocalSearch(request: request).start { response, error in  //검색 시작, 응답이 오면 실행, 에러가 없고 결과가 있는 경우 계속 진행
                defer { group.leave() } //함수가 끝날때 무조건 leave() 호출해서 그룹 정리할 것.
                guard let items = response?.mapItems, error == nil else { return }
                let namedMountains = items.filter { item in
                    item.name?.hasSuffix("산") ?? false  //여기서 검색 결과에 '산'이 들어가는지 filtering 하는 이유 : 안하면 운제산은 안나오고 운제읍이 검색됨.
                }
                
                let results: [Mountain] = namedMountains.map { item in
                    let placemark = item.placemark
                    // 주소 컴포넌트
                    let street = placemark.thoroughfare ?? "" //~리
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
                        distance: 0,    //distance 는 0으로 넣고 차후 다시 계산해서 넣음.
                        summitMarkerCount: (item.name == "봉좌산" ? 2 : 1)
                        //TODO: 일단 하드코딩, 나중에 모델 개수 카운트해서 넣어야.
                    )
                }
                
                DispatchQueue.main.async{   //메인에서 처리.
                    found.append(contentsOf: results)
                }
            }
        }
        group.notify(queue: .main) { //없으면 비동기함수가 끝나기 전에 할당해서 mountains 계속 비어있음
            self.mountains = found
            print("진짜 검색 완료: \(self.mountains.map(\.name))")
        }
        
    }
    
    //현재 사용자 위치를 기준으로 radius 안에 있는 산들만 필터링해서 각 산의 distance 를 int 로 변환해 넣고, 거리 오름차순으로 변환해서 저장.
    func getClosestMountains(from location: CLLocation, within radius: Double = 30_000) -> [Mountain] {
        return mountains.compactMap { mountain in
            let distance = CLLocation(
                latitude: mountain.coordinate.latitude,
                longitude: mountain.coordinate.longitude
            ).distance(from: location)
            guard distance <= radius else { return nil }    //여기서도 한번 더 거리 필터링 하는 것.
            var m = mountain
            m.distance = Int(distance)
            return m
        }
        .sorted { $0.distance < $1.distance }
    }

    //다른데서도 쓰려고 뺐어요 거리계산
    func distance(from location: CLLocation, to mountain: Mountain) -> CLLocationDistance {
        CLLocation(
            latitude: mountain.coordinate.latitude,
            longitude: mountain.coordinate.longitude
        ).distance(from: location)
    }
    
   
}

