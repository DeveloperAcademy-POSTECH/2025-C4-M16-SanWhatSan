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
    @StateObject var viewModel = CameraViewModel()
    @EnvironmentObject var mountainListViewModel: MountainListViewModel
    // MARK: 리팩토링?
    @State var chosenMountain: Mountain?
    @State var isImageViewActive = false
    @State var capturedImage: UIImage?
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // TODO: chosenMountain
                if let selected = chosenMountain ?? mountainListViewModel.closestMountains.first {
                    Text("선택한 산: \(selected.name)")
                        .font(.headline)
                        .padding(.top)
                } else {
                    Text("위치 기반 산 검색이 아직 준비되지 않았습니다.")
                        .font(.headline)
                        .padding(.top)
                }
                
                NavigationLink{
                    MountainListView(chosenMountain: $chosenMountain)
                } label: {
                    Text("다른 산으로 이동")
                        .padding(10)
                }
                
                ARViewContainer(arManager: viewModel.arManager)
                    .edgesIgnoringSafeArea(.all)

                Button("촬영") {
                    // TODO: navigator.push(ImageView(~~~~))
                    viewModel.arManager.captureSnapshot { image in
                        if let image = image {
                            capturedImage = image
                            isImageViewActive = true
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                viewModel.startARSession()
            }
            
            // TODO: deprecated -> 나중에 navigationDestination으로 바꾸기(리팩토링)
            NavigationLink(
                destination: ImageView(image: capturedImage ?? UIImage()),
                isActive: $isImageViewActive,
                label: { EmptyView() }
            )
        }
    }
}

#Preview {
    CameraView()
}
