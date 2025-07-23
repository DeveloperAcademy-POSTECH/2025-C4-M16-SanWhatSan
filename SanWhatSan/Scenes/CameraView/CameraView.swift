//
//  CameraView.swift
//  SanWhatSan
//
//  Created by Zhen on 7/7/25.
//
// ⚠️ Navigation 구조는 Coordinator 기반으로 수정되었습니다.
// 기존 NavigationLink 기반 코드는 모두 제거되었으며,
// 촬영 후 자동 이동은 coordinator.push(.imageView(...)) 방식으로 전환되었습니다.
// 커스텀 뷰 요소는 병합된 구조 위에 다시 통합되었음.

import SwiftUI
import ARKit
import RealityKit

struct CameraView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @StateObject var viewModel = CameraViewModel()
    @StateObject private var mountainViewModel = MountainListViewModel()
    @State var isImageViewActive = false
    @State var capturedImage: UIImage?
    @State private var showFlash = false

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 95) {
                if let selected = mountainViewModel.selectedMountain {
                    HStack(spacing: 4) {
                        Image(systemName: "mountain.2.fill")
                            .foregroundColor(Color(red: 0.11, green: 0.72, blue: 0.59))
                        Text("현재 위치는 ")
                            .font(Font.custom("Pretendard", size: 16).weight(.semibold))
                            .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78)) +
                        Text("\(selected.name)")
                            .font(Font.custom("Pretendard", size: 16).weight(.bold))
                            .foregroundColor(.black) +
                        Text("이산")
                            .font(Font.custom("Pretendard", size: 16).weight(.semibold))
                            .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78))
                    }
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "mountain.2.fill")
                            .foregroundColor(Color(red: 0.11, green: 0.72, blue: 0.59))
                        Text("현재 산이 아니산")
                            .font(Font.custom("Pretendard", size: 16).weight(.semibold))
                            .foregroundColor(.black)
                    }
                }

                Button {
                    coordinator.push(.mountainListView(mountainViewModel))
                } label: {
                    Text(viewModel.selectedMountain == nil ? "산에 있산?" : "이 산이 아니산?")
                        .font(Font.custom("Pretendard", size: 12).weight(.medium))
                        .underline(true, pattern: .solid)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.78))
                        .frame(width: 90, alignment: .bottom)
                }
            }
            .padding(.top, 56)
            .padding(.leading, 33)
            .frame(maxWidth: .infinity, alignment: .leading)

            ZStack {
                ARViewContainer(arManager: viewModel.arManager)
                    .ignoresSafeArea()

                if showFlash {
                    Color.white
                        .ignoresSafeArea()
                        .transition(.opacity)
                }

                VStack {
                    Spacer()
                    HStack {
                        Button {
                            coordinator.push(.albumView)
                        } label: {
                            Text("앨범")
                        }
                        .padding(35)

                        Spacer()

                        Button {
                            viewModel.arManager.captureSnapshot { image in
                                if let image = image {
                                    PhotoManager.shared.saveImageToLocalPhoto(image)
                                    withAnimation(.easeIn(duration: 0.05)) {
                                        showFlash = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            showFlash = false
                                        }
                                    }
                                }
                            }
                        } label: {
                            Image("CameraButton")
                                .resizable()
                                .frame(width: 73, height: 73)
                                .shadow(color: .black.opacity(0.1), radius: 7.5, x: 0, y: -4)
                        }
                        .padding(.bottom, 32)

                        Spacer()

                        Button {

                        } label: {
                            Text("정상석")
                        }
                        .padding(35)
                    }
                }
            }
        }
        .onAppear {
            viewModel.startARSession()
        }
    }

}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
            .environmentObject(NavigationCoordinator())
    }
}
