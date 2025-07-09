//
//  CameraView.swift
//  SanWhatSan
//
//  Created by Zhen on 7/7/25.
//

import SwiftUI
import ARKit
import RealityKit

struct CameraView: View {
    @StateObject private var coordinator = Coordinator()
    @State private var capturedImage: UIImage? = nil
    @State private var isShowingImageView = false
    var body: some View {
        
        NavigationStack{
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = width * 4 / 3
                VStack{
                    
                    Spacer()
                    
                    NavigationLink{
                        MountainListView()
                    } label: {
                        Text("다른 산으로 이동")
                            .padding(10)
                    }
                    
                    Spacer()
                    
                    ARViewContainer(coordinator: coordinator)
                        .frame(width: width, height: height)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(16)
                        .clipped()
                    
                    HStack {
                        Button("고정") {
                            coordinator.placeModel()
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .padding(.bottom, 40)

                        Button("촬영") {
                            coordinator.captureSnapshot { image in
                                if let image = image {
                                    self.capturedImage = image
                                    self.isShowingImageView = true
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .padding(.bottom, 40)
                    }
                }
            }
            
            NavigationLink(
                destination: Group {
                    if let capturedImage {
                        ImageView(
                            image: capturedImage,
                            onRetake: {
                                self.isShowingImageView = false
                                self.capturedImage = nil
                            }
                        )
                    }
                },
                isActive: $isShowingImageView
            ) {
                EmptyView()
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var coordinator: Coordinator

    func makeCoordinator() -> Coordinator {
        coordinator
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        coordinator.arView = arView

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            config.frameSemantics.insert(.personSegmentationWithDepth)
        }

        arView.session.delegate = coordinator
        arView.session.run(config)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // No update needed
    }
}

#Preview {
    CameraView()
}
