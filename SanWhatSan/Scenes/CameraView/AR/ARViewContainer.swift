//
//  ARViewContainer.swift
//  SanWhatSan
//
//  Created by 박난 on 7/10/25.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    var arManager: ARManager
    
    func makeCoordinator() -> ARCoordinator {
        arManager.coordinator
    }

    func makeUIView(context: Context) -> ARView {
        arManager.setupARView()
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}
