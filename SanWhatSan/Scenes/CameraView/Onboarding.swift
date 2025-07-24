//
//  Onboarding.swift
//  SanWhatSan
//
//  Created by 최예은 on 7/24/25.
//

import SwiftUI

struct CameraWrapperView: View {
    let onFinish: () -> Void   // ✅ 외부에서 닫기

    @State private var currentPage = 0
    let tutorialImages = ["카메라뷰-1", "카메라뷰-2"]

    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                ForEach(0..<tutorialImages.count, id: \.self) { index in
                    Image(tutorialImages[index])
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

            if currentPage == tutorialImages.count - 1 {
                VStack {
                    Spacer()
                    Button("시작하기") {
                        withAnimation {
                            onFinish()   // ✅ 외부에서 fullScreenCover 닫기
                        }
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                    .padding(.bottom, 50)
                }
            }
        }
    }
}
