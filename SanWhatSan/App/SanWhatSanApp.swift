//
//  SanWhatSanApp.swift
//  SanWhatSan
//
//  Created by Zhen on 7/7/25.
//

import SwiftUI

@main

struct SanWhatSanApp: App {
    @StateObject var coordinator = NavigationCoordinator()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false


    var locationService = LocationService.shared
    
    var body: some Scene {
        WindowGroup {
            AppNavigationView()
                .preferredColorScheme(.light)
                .environmentObject(coordinator)
                .onAppear {
                    locationService.requestLocationAccess()
                }
                .fullScreenCover(isPresented: .constant(!hasSeenOnboarding)) {
                    CameraWrapperView {
                        hasSeenOnboarding = true
                    }
                }
        }
    }
}
import SwiftUI

