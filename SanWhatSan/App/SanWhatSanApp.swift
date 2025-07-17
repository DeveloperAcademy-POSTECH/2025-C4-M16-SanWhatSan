//
//  SanWhatSanApp.swift
//  SanWhatSan
//
//  Created by Zhen on 7/7/25.
//

import SwiftUI

@main
struct SanWhatSanApp: App {
    @StateObject private var LocationViewModel = MountainListViewModel()
    //@StateObject private var cameraViewModel = CameraViewModel()
    
    var body: some Scene {
        WindowGroup {
            CameraView()
                .preferredColorScheme(.light)
                .onAppear{
                    LocationViewModel.requestLocationAccess()
                }
        }
    }
}
