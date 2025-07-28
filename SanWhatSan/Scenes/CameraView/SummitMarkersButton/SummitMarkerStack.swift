//
//  SummitMarkerStack.swift
//  SanWhatSan
//
//  Created by Zhen on 7/24/25.
//

import SwiftUI

struct SummitMarkerStack: View {
    @StateObject var viewModel: CameraViewModel
    @State private var showOtherMarkers = false
    @State private var selectedIndex = 0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            let name = viewModel.selectedMountain?.name ?? ""
            let markers = viewModel.summitMarkers(for: name)
            let count = markers.count
            let safeIndex = min(selectedIndex, max(0, count - 1))
            let currentMarker = markers[safeIndex]
            
            // 나머지 비석 선택 버튼들 (선택된 것 제외)
            if count > 1 && showOtherMarkers {
                ForEach(0..<count, id: \.self) { index in
                    if index != safeIndex {
                        let marker = markers[index]
                        Button {
                            withAnimation {
                                selectedIndex = index
                                viewModel.summitMarker = marker
                                viewModel.arManager.removeModelInScene()
                                showOtherMarkers = false
                            }
                        } label: {
                            SummitMarkerButton(previewImg: marker.previewImageFileName)
                        }
                        //TODO: 여기서 기준이 index 라서 두번째 세번째가 선택되었을때 나머지가 안보이는 것 같음
                        .offset(x: -30, y: CGFloat(-100 * (index - safeIndex)))
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showOtherMarkers)
                    }
                }
            }

            // 메인 버튼
            Button {
                withAnimation {
                    selectedIndex = safeIndex
                    viewModel.summitMarker = currentMarker
                    viewModel.arManager.removeModelInScene()
                    if count > 1 {
                        showOtherMarkers.toggle()
                    }
                }
            } label: {
                SummitMarkerButton(previewImg: currentMarker.previewImageFileName)
            }
            .padding(.bottom, 32)
            .padding(.trailing, 32)
        }
        .onChange(of: viewModel.selectedMountain) { _ in
            selectedIndex = 0
            showOtherMarkers = false
        }
    }
}
