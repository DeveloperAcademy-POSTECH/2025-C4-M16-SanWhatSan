//
//  MountainMapView.swift
//  SanWhatSan
//
//  Created by Zhen on 7/20/25.
//

import SwiftUI
import MapKit

struct MountainMapView: View {
    @Binding var region: MKCoordinateRegion
    //@Binding var closetMountain: view?
    let mountains: [Mountain]

    var body: some View {
        
        if mountains.isEmpty {
            Map(
                coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .constant(.follow)
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
                MountainMapAnnotationView(mountain: mountain)
              }
            }
            .ignoresSafeArea(edges: .all)
        }
    }
}
