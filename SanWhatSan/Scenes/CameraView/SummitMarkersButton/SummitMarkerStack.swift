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

    var body: some View {
        ZStack(alignment: .bottom) {
            let count = viewModel.selectedMountain?.summitMarkerCount ?? 1
            let name = viewModel.selectedMountain?.name ?? ""

            // 메인 버튼 (index 0)
            Button {
                viewModel.summitMarker = viewModel.updateSummitMarker(for: name, index: 0)
                if count > 1 {
                    withAnimation {
                        showOtherMarkers.toggle()
                    }
                }
            } label: {
                let previewImg = viewModel.updateSummitMarker(for: name, index: 0).previewImageFileName
                SummitMarkerButton(previewImg: previewImg)
            }
            .padding(35)

            // 위로 펼쳐지는 버튼들 (index > 0)
            if showOtherMarkers {
                ForEach(1..<count, id: \.self) { index in
                    Button {
                        viewModel.summitMarker = viewModel.updateSummitMarker(for: name, index: index)
                        viewModel.arManager.removeModelInScene()
                        showOtherMarkers = false
                    } label: {
                        let previewImg = viewModel.updateSummitMarker(for: name, index: index).previewImageFileName
                        SummitMarkerButton(previewImg: previewImg)
                    }
                    .offset(y: CGFloat(-100 * index))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showOtherMarkers)
                }
            }
        }
    }
}
