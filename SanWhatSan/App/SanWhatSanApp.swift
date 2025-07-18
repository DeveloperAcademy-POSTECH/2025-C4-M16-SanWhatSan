//
//  SanWhatSanApp.swift
//  SanWhatSan
//
//  Created by Zhen on 7/7/25.
//

import SwiftUI

@main
struct SanWhatSanApp: App {
//    @StateObject private var LocationViewModel = MountainListViewModel()
    //@StateObject private var cameraViewModel = CameraViewModel()
    @StateObject var coordinator = NavigationCoordinator()
    
    var body: some Scene {
        WindowGroup {
            AppNavigationView()
//                .onAppear{
//                    LocationViewModel.requestLocationAccess() // TODO: 현재는 CameraView에서 하는데 나중에 앱 실행할 때로 바꾸기(LocationService.swift 따로 빼야 할듯)
//                }
                .environmentObject(coordinator)
        }
    }
}
