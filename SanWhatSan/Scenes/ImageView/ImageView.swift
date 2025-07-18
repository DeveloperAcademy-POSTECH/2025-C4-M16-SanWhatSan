//
//  ImageView.swift
//  SanWhatSan
//
//  Created by Zhen on 7/7/25.
//

import SwiftUI

struct ImageView: View {
//    let image: UIImage
    @EnvironmentObject private var coordinator: NavigationCoordinator
    let displayImage: DisplayImage
    @State private var showShareSheet = false
    @State private var showSaveAlert = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()

            Image(uiImage: displayImage.image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300, maxHeight: 400)
                .padding(.bottom, 200)
                .ignoresSafeArea()

            HStack(spacing: 30) {
                Button(action: {
                    coordinator.pop()
                }) {
                    Label("닫기", systemImage: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }


                Button(action: {
                    UIImageWriteToSavedPhotosAlbum(displayImage.image, nil, nil, nil)
                    showSaveAlert = true
                }) {
                    Label("저장", systemImage: "square.and.arrow.down")
                        .font(.title)
                        .foregroundColor(.white)
                }

                Button(action: {
                    showShareSheet = true
                }) {
                    Label("공유", systemImage: "square.and.arrow.up")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .padding(.bottom, 40)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [displayImage.image])
        }
        .alert("사진이 앨범에 저장되었습니다", isPresented: $showSaveAlert) {
            Button("확인", role: .cancel) { }
        }
    }
}

#Preview {
    ImageView(
        displayImage: DisplayImage(
            id: UUID(),
            image: UIImage(named: "FakePhoto")!)
    )
}


