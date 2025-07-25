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
            let count = (viewModel.selectedMountain?.summitMarkerCount ?? 0) + 1
            
            // 나머지 선택지 버튼들 (index ≠ selectedIndex)
            if showOtherMarkers {
                ForEach(0..<count, id: \.self) { index in
                    if index != selectedIndex {
                        Button {
                            withAnimation {
                                selectedIndex = index
                                viewModel.summitMarker = viewModel.updateSummitMarker(for: name, index: index)
                                viewModel.arManager.removeModelInScene()
                                showOtherMarkers = false
                            }
                        } label: {
                            let previewImg = viewModel.updateSummitMarker(for: name, index: index).previewImageFileName
                            SummitMarkerButton(previewImg: previewImg)
                        }
                        .offset(x: -30, y: CGFloat(-100 * (index - selectedIndex)))
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
                    viewModel.summitMarker = viewModel.updateSummitMarker(for: name, index: selectedIndex)
                    viewModel.arManager.removeModelInScene()
                    if count > 1 {
                        showOtherMarkers.toggle()
                    }
                }
            } label: {
                let previewImg = viewModel.updateSummitMarker(for: name, index: selectedIndex).previewImageFileName
                SummitMarkerButton(previewImg: previewImg)
            }
            .padding(.bottom, 32)
            .padding(.trailing, 32)
        }
    }
}
