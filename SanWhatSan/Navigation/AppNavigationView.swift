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
//                    case .imageView(let displayImage):
//                        ImageView(displayImage: displayImage)
                    case .mountainListView:
                        MountainListView()
                    case .albumView:
                        AlbumView()
                    case .photoDetailView(let displayImage):
                        PhotoDetailView(displayImage: displayImage)
//                    case .frameView():
//                        FrameView()   // TODO: 나중에 FrameView 파일 만들면 주석 해제하기
                    }
                }
        }
    }
}
