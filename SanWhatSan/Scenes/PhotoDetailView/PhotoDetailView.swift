//
//  PhotoDeatailView.swift
//  SanWhatSan
//
//  Created by 장수민 on 7/20/25.
//

import SwiftUI

struct PhotoDetailView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    let photo: Photo

    @State private var isShareSheetPresented = false
    @State private var showDeleteAlert = false

    @State private var showSaveToast = false   // ✅ 저장 완료 토스트
    @State private var showDeleteToast = false // ✅ 삭제 완료 토스트

    //MARK: - 프레임 선택 관련 상태
    @State private var isFramePickerPresented = false
    @State private var selectedFrame: UIImage? = nil

    let frameOptions: [UIImage] = [
        UIImage(named: "frame00"),
        UIImage(named: "frame01"),
        UIImage(named: "frame02"),
        UIImage(named: "frame03"),
        UIImage(named: "frame04"),
        UIImage(named: "frame05"),
        UIImage(named: "frame06"),
        UIImage(named: "frame07")
    ].compactMap { $0 }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - 이미지 영역
            VStack {
                Spacer(minLength: 0)

                GeometryReader { geometry in
                    let width = geometry.size.width * 0.82
                    let height = width * (16 / 9)

                    VStack {
                        Spacer().frame(height: 15) // 위에서 15 떨어지게
                        HStack {
                            Spacer()
                            ZStack {
                                Image(uiImage: PhotoManager.shared.loadImage(from: photo) ?? UIImage())
                                    .resizable()
                                    .aspectRatio(9/16, contentMode: .fit)
                                    .frame(width: width, height: height)
                                    .clipped()

                                if let frame = selectedFrame {
                                    Image(uiImage: frame)
                                        .resizable()
                                        .aspectRatio(9/16, contentMode: .fit)
                                        .frame(width: width, height: height)
                                        .clipped()
                                        .opacity(0.9)
                                }
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }

                Spacer(minLength: 0)
            }

            // MARK: - 하단 버튼들
            HStack {
                Button(action: {
                    isFramePickerPresented = true
                }) {
                    Image(systemName: "person.crop.artframe")
                        .font(.system(size: 22))
                        .foregroundColor(.mint)
                        .frame(width: 50, height: 50)
                        .background(Color(UIColor.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }

                Spacer()

                Button(action: {
                    if let image = PhotoManager.shared.loadImage(from: photo) {
                        let finalImage = merge(photo: image, with: selectedFrame)
                        UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)

                        // ✅ 저장 토스트 표시
                        showSaveToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSaveToast = false
                        }
                    }
                }) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 22))
                        .foregroundColor(.mint)
                        .frame(width: 50, height: 50)
                        .background(Color(UIColor.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }

                Button(action: {
                    isShareSheetPresented = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 22))
                        .foregroundColor(.mint)
                        .frame(width: 50, height: 50)
                        .background(Color.neutrals5)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }

                Button(action: {
                    showDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 22))
                        .foregroundColor(.mint)
                        .frame(width: 50, height: 50)
                        .background(Color(UIColor.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("사진 삭제"),
                        message: Text("정말로 이 사진을 삭제하겠산?"),
                        primaryButton: .destructive(Text("삭제")) {
                            let fileURL = FileManager.default
                                .urls(for: .documentDirectory, in: .userDomainMask)[0]
                                .appendingPathComponent("LocalPhoto")
                                .appendingPathComponent(photo.filename)
                            try? FileManager.default.removeItem(at: fileURL)

                            // ✅ 삭제 토스트 표시
                            showDeleteToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showDeleteToast = false
                                coordinator.pop()
                            }
                        },
                        secondaryButton: .cancel(Text("취소"))
                    )
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .background(Color.white.ignoresSafeArea())
        .overlay(
            Group {
                if showSaveToast {
                    toastView(text: "사진이 저장되었산")
                } else if showDeleteToast {
                    toastView(text: "사진이 삭제되었산")
                }
            }
        )
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(Font.custom("SF Pro", size: 16))
                        .foregroundColor(.black)
                        .frame(width: 35, height: 35)
                        .background(Color.neutrals5)
                        .clipShape(Circle())
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("\(formatDate(photo.savedDate))")
            }
        }
        .sheet(isPresented: $isShareSheetPresented) {
            if let image = PhotoManager.shared.loadImage(from: photo) {
                ShareSheet(activityItems: [image])
            }
        }
        .sheet(isPresented: $isFramePickerPresented) {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(frameOptions, id: \ .self) { frame in
                            Image(uiImage: frame)
                                .resizable()
                                .frame(width: 66, height: 66)
                                .border(Color.gray, width: 0.2)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(frame == selectedFrame ? Color.green : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture {
                                    selectedFrame = frame
                                }
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            .presentationDetents([.height(113)])
        }
    }

    // ✅ 토스트 뷰 추가
    @ViewBuilder
    private func toastView(text: String) -> some View {
        VStack {
            Spacer()

            HStack(spacing: 8) {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color("AccentColor"))
                Text(text)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color("Neutrals2"))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
            )
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            .padding(.bottom, 570)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.3), value: text)
        }
    }
}

func merge(photo: UIImage, with frame: UIImage?) -> UIImage {
    let size = photo.size
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

    photo.draw(in: CGRect(origin: .zero, size: size))

    if let frame = frame {
        frame.draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: 0.9)
    }

    let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return combinedImage ?? photo
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
    formatter.dateFormat = "yyyy년 M월 d일"
    return formatter.string(from: date)
}



// MARK: - 대체 이미지 (프리뷰용)
//extension UIImage {
//    static func solidColor(_ color: UIColor = .gray, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: size)
//        return renderer.image { context in
//            color.setFill()
//            context.fill(CGRect(origin: .zero, size: size))
//        }
//    }
//}

// MARK: - 프리뷰
#Preview {
//    PhotoDetailView(
//        photo: Photo(id: UUID(), filename: "", savedDate: Date(), location: Coordinate(latitude: 0, longitude: 0))
//    )
}

