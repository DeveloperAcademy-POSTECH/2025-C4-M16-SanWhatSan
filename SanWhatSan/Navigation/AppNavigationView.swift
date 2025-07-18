//
//  AppNavigationView.swift
//  SanWhatSan
//
//  Created by 박난 on 7/10/25.
//

import SwiftUI

struct AppNavigationView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path){
            CameraView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .cameraView:
                        CameraView()
                    case .imageView(let displayImage):
                        ImageView(displayImage: displayImage)
                    case .mountainListView:
                        MountainListView()
//                    case .albumView():
//                        AlbumView()
//                    case .photoDetailView():
//                        PhotoDetailView()
//                    case .frameView():
//                        FrameView()
                    }
                }
        }
    }
}
