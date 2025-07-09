//
//  ImageView.swift
//  SanWhatSan
//
//  Created by Zhen on 7/7/25.
//

import SwiftUI

struct ImageView: View {
    let image: UIImage
    let onRetake: () -> Void // ❌ 버튼용 콜백
    @State private var showShareSheet = false
    @State private var showSaveAlert = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300, maxHeight: 400)
                .padding(.bottom, 200)
                .ignoresSafeArea()

            HStack(spacing: 30) {
                Button(action: {
                    onRetake()
                }) {
                    Label("닫기", systemImage: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }


                Button(action: {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
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
            ShareSheet(activityItems: [image])
        }
        .alert("사진이 앨범에 저장되었습니다", isPresented: $showSaveAlert) {
            Button("확인", role: .cancel) { }
        }
    }
}

#Preview {
    ImageView(
        image: UIImage(named: "FakePhoto")!, // 임시 이미지로 Assets에 있는 FakePhoto 사용함
        //image: UIImage(systemName: "photo")!, // 임시 이미지
        onRetake: {}
    )
}


