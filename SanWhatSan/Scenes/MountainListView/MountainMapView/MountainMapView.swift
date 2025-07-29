//
//  MountainMapView.swift
//  SanWhatSan
//
//  Created by Zhen on 7/20/25.
//

import SwiftUI
import MapKit

struct MountainMapView: View {
    @Binding var region: MKCoordinateRegion //보여지는 영역 구조체 (어디를 중심으로, 어디까지)
    //@Binding var closetMountain: view?
    let mountains: [Mountain]
    let selectedMountain: Mountain?

    var body: some View {
        
        //검색된 산이 하나도 없을때
        if mountains.isEmpty {
            Map(
                coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .constant(.none)
            )
            .ignoresSafeArea(edges: .all)
        }
        else{
            Map(
              coordinateRegion: $region,
              interactionModes: .all,
              showsUserLocation: true,
              userTrackingMode: .constant(.none),
              annotationItems: mountains
            ) { mountain in
              MapAnnotation(coordinate: mountain.coordinate.clLocationCoordinate2D) {
                  MountainMapAnnotationView(
                                      mountain: mountain,
                                      isSelected: mountain.id == selectedMountain?.id
                                  )              }
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}
