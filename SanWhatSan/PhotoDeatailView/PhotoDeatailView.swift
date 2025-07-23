//
//  PhotoDeatailView.swift
//  SanWhatSan
//
//  Created by 장수민 on 7/20/25.
//

import SwiftUI
//

struct PhotoDetailView: View {
    @Environment(\.dismiss) var dismiss

    let image: UIImage
    let onDelete: () -> Void

    @State private var isShareSheetPresented = false
    @State private var showDeleteAlert = false

//MARK: - 프레임 선택 관련 상태
    @State private var isFramePickerPresented = false
    @State private var selectedFrame: UIImage? = nil

//MARK: - 예시 프레임 이미지 배열 (실제 프로젝트에선 Asset 이미지로 대체)
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
// MARK: - 상단 바 (뒤로 가기)
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color(UIColor.systemGray5))
                        .clipShape(Circle())
                }
                Spacer()
                Spacer().frame(width: 40) // 균형 맞추기용
            }
            .padding(.horizontal)
            .padding(.top, 16)

// MARK: - 이미지 영역
            GeometryReader { geometry in
                VStack {
                    Spacer(minLength: 0)
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(9/16, contentMode: .fit)
                        .frame(width: geometry.size.width * 0.85)
                        .frame(maxWidth: geometry.size.width)
                        .clipped()
                        // ✅ 프레임 오버레이
                        .overlay {
                            if let frame = selectedFrame {
                                Image(uiImage: frame)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .opacity(0.9)
                            }
                        }
                    Spacer(minLength: 0)
                }
            }

// MARK: - 하단 버튼들
            HStack {
// MARK: - 프레임 꾸미기 버튼
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

// MARK: - 저장 버튼
                Button(action: {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: 22))
                        .foregroundColor(.mint)
                        .frame(width: 50, height: 50)
                        .background(Color(UIColor.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }

// MARK: - 공유 버튼
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

// MARK: - 삭제 버튼
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
                            onDelete()
                            dismiss()
                        },
                        secondaryButton: .cancel(Text("취소"))
                    )
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())

//MARK: -  공유 시트
        .sheet(isPresented: $isShareSheetPresented) {
            ShareSheet(activityItems: [image])
        }

// MARK: -  프레임 선택 시트
        .sheet(isPresented: $isFramePickerPresented) {
            VStack {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(frameOptions, id: \.self) { frame in
                            Image(uiImage: frame)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .border(Color.gray, width: 0.2)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(frame == selectedFrame ? Color.green : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture {
                                    selectedFrame = frame
                                    isFramePickerPresented = false
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
}

// MARK: - 대체 이미지 (프리뷰용)
extension UIImage {
    static func solidColor(_ color: UIColor = .gray, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}

// MARK: - 프리뷰
#Preview {
    PhotoDetailView(
        image: UIImage.solidColor(),
        onDelete: {}
    )
}

