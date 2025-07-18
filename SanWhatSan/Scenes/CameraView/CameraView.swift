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
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @StateObject var viewModel = CameraViewModel()
//    @StateObject var mountainListViewModel = MountainListViewModel()
//    @State var chosenMountain: Mountain?
    @State var isImageViewActive = false
    @State var capturedImage: UIImage?
    
    var body: some View {
            VStack {
                
                // TODO: chosenMountain
                if let selected = viewModel.selectedMountain {
                    Text("선택한 산: \(selected.name)")
                        .font(.headline)
                        .padding(.top)
                } else {
                    Text("위치 기반 산 검색이 아직 준비되지 않았습니다.")
                        .font(.headline)
                        .padding(.top)
                }
                
                Button {
                    coordinator.push(.mountainListView)
                } label: {
                    Text("다른 산으로 이동")
                        .padding(10)
                }
                ARViewContainer(arManager: viewModel.arManager)
                    .edgesIgnoringSafeArea(.all)

                Button("촬영") {
                    viewModel.arManager.captureSnapshot { image in
                        if let image = image {
                            coordinator.push(
                                .imageView(DisplayImage(id: UUID(), image: image))
                            )
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                viewModel.startARSession()
            }
        }
    }

#Preview {
    CameraView()
}
