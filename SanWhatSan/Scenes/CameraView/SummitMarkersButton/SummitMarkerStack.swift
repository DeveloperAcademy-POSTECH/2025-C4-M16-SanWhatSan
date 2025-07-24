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
    
    var body : some View {
        ZStack(alignment: .bottom){
            let count = viewModel.selectedMountain?.summitMarkerCount ?? 1

            ForEach(0..<count, id: \.self) { index in
                if showOtherMarkers && index > 0 {
                    Button {
                        let isFallback = index == 1
                        let name = viewModel.selectedMountain?.name ?? ""
                        viewModel.summitMarker = viewModel.updateSummitMarker(for: name, isFallback: isFallback)
                        showOtherMarkers = false
                    } label: {
                        SummitMarkerButton(thumbImg: viewModel.summitMarker?.previewImageFileName ?? "tmp")
                    }
                    .offset(y: CGFloat(-100 * index))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showOtherMarkers)
                }
            }
            Button {
                if (viewModel.selectedMountain?.summitMarkerCount ?? 1) > 1 {
                    withAnimation {
                        showOtherMarkers.toggle()
                    }
                } else {
                    let name = viewModel.selectedMountain?.name ?? ""
                    viewModel.summitMarker = viewModel.updateSummitMarker(for: name, isFallback: false)
                }
            } label: {
                
                //TODO: summitMarker 가 할당되기 전에 이 뷰를 그려서 기본 sws로 나옴.. default 이미지 받으면 바꾸기
                SummitMarkerButton(thumbImg:viewModel.summitMarker?.previewImageFileName ?? "sws")
            }
            .padding(35)
        }
    }
}


