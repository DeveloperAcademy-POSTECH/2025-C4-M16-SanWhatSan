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
    
    let summitMarkerCandidates: [(name: String, imageName: String)] = [
        ("도음산", "tmp"),
        ("봉좌산", "tmp2"),
        ("기본", "tmp2")
    ]
    
    var body : some View {
        ZStack(alignment: .bottom){
            let count = viewModel.selectedMountain?.summitMarkerCount ?? 1

            ForEach(0..<count, id: \.self) { index in
                if showOtherMarkers && index > 0 {
                    Button {
                        let isFallback = index == 1 // index 기준으로 fallback 구분
                        let name = viewModel.selectedMountain?.name ?? ""
                        viewModel.summitMarker = viewModel.updateSummitMarker(for: name, isFallback: isFallback)
                        showOtherMarkers = false
                    } label: {
                        SummitMarkerButton(thumbImg: "tmp")
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
                SummitMarkerButton()
            }
            .padding(35)
        }
    }
}


