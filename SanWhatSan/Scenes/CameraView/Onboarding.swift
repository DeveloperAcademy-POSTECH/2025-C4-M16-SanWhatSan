//
//  Onboarding.swift
//  SanWhatSan
//
//  Created by 최예은 on 7/24/25.
//

//import SwiftUI
//
//struct CameraWrapperView: View {
//    let onFinish: () -> Void   // ✅ 외부에서 닫기
//
//    @State private var currentPage = 0
//    let tutorialImages = ["OnBoarding1", "OnBoarding2"]
//
//    var body: some View {
//        ZStack {
//            TabView(selection: $currentPage) {
//                ForEach(0..<tutorialImages.count, id: \.self) { index in
//                    Image(tutorialImages[index])
//                        .resizable()
//                        .scaledToFill()
//                        .ignoresSafeArea()
//                        .tag(index)
//                }
//            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
//            VStack {
//                                Spacer()
//                                HStack(spacing: 12) {
//                                    ForEach(0..<tutorialImages.count, id: \.self) { index in
//                                        Circle()
//                                            .fill(currentPage == index ? Color("1DB796") : Color("D9D9D9"))
//                                            .frame(width: 8, height: 8)
//                                    }
//                                }
//                                .padding(.bottom, 120) // 위치 조절 y=600 근처
//                            }
//
//            if currentPage == tutorialImages.count - 1 {
//                VStack {
//                    Spacer()
//                    Button(action: {
//                        withAnimation {
//                            onFinish() // ✅ 외부에서 showTutorial = false 해줌
//                        }
//                    }) {
//                        Text("시작하기")
//                            .foregroundColor(.white)
//                            .font(.headline)
//                            .frame(width: 315, height: 55)
//                            .background(Color("1DB796"))
//                            .cornerRadius(12)
//                    }
//                    .padding(.bottom, 40) // y=700 근처
//                }
//            }
//        }
//    }
//}
import SwiftUI

struct CameraWrapperView: View {
    let onFinish: () -> Void
    @State private var currentPage = 0

    let tutorialImages = ["OnBoarding1", "OnBoarding2"]

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
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // 기본 인디케이터 숨김

            // ✅ 커스텀 슬라이드 인디케이터
            VStack {
                Spacer()
                HStack(spacing: 12) {
                    ForEach(0..<tutorialImages.count, id: \.self) { index in
                        Circle()
                            .fill(
                                currentPage == index
                                ? Color(red: 29/255, green: 183/255, blue: 150/255) // 1DB796
                                : Color(red: 217/255, green: 217/255, blue: 217/255) // D9D9D9
                            )
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 220) // y=600 근처
            }

            // ✅ 시작하기 버튼
            if currentPage == tutorialImages.count - 1 {
                VStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            onFinish()
                        }
                    }) {
                        Text("시작하기")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 315, height: 55)
                            .background(Color(red: 29/255, green: 183/255, blue: 150/255)) // 1DB796
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 40) // y=700 근처
                }

            }
        }
        .ignoresSafeArea(edges: .top) // ✅ 전체 SafeArea 무시
        .navigationBarHidden(true) // ✅ Navigation Bar 숨기기
    }
}
