//
//  AlbumView.swift
//  SanWhatSan
//
//  Created by 장수민 on 7/17/25.
//

import SwiftUI
import Photos

struct AlbumView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    
    @State private var photos: [Photo] = []
    @State private var selectedPhotos = Set<Photo>()
    
    @State private var isSelectionMode = false
    @State private var showDeleteAlert = false
    @State private var isShareSheetPresented = false
    
    @State private var showSaveToast = false   // ✅ 저장 완료 토스트
    @State private var showDeleteToast = false // ✅ 삭제 완료 토스트
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
//MARK: - 사진이 없을때 중앙 메시지 또는 사진 정렬
                if photos.isEmpty {
                    Image("empty")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white) // 배경색 채우기
                    
                } else {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(photos) { photo in
                            if let image = PhotoManager.shared.loadImage(from: photo) {
                                imageCell(image, photo)
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 10)
                }
            }
            
//MARK: - 사진 선택 모드 하단 바
            if isSelectionMode {
                Divider()
                HStack {
                    Button {
                        PhotoManager.shared.saveToPhotoLibrary(Array(selectedPhotos))
                        selectedPhotos.removeAll()
                        isSelectionMode = false
                        
// ✅ 저장 토스트 표시
                        showSaveToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSaveToast = false
                        }
                        
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .font(
                                Font.custom("SF Pro", size: 23)
                                    .weight(.light)
                            )
                            .foregroundColor(Color("AccentColor"))
                        /*                                .frame(width: 20, height: 22, alignment: .center)  */                      }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Text("\(selectedPhotos.count)장 선택됨")
                        .font(Font.custom("Pretendard", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button {
                        isShareSheetPresented = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(
                                Font.custom("SF Pro", size: 23)
                                    .weight(.light)
                            )
                            .foregroundColor(Color("AccentColor"))
                    }
                    
                    Button {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .font(
                                Font.custom("SF Pro", size: 23)
                                    .weight(.light)
                            )
                            .foregroundColor(Color("AccentColor"))
                    }
                    .padding(.trailing)
                }
                .padding(.vertical, 12)
                .background(Color.white)
            }
        }
        .overlay(
            Group {
                if showSaveToast {
                    toastView(text: "저장이 완료되었산!")
                } else if showDeleteToast {
                    toastView(text: "사진이 삭제되었산!")
                }
            }
        )
        .navigationBarBackButtonHidden(true)
.navigationBarTitleDisplayMode(.inline)
        .toolbar {
//MARK: - 뒤로 가기 버튼
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
//MARK: - 선택 취소 버튼
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if isSelectionMode {
                        selectedPhotos.removeAll()
                    }
                    isSelectionMode.toggle()
                } label: {
                    Text(isSelectionMode ? "취소" : "선택")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(width: 63, height: 35)
                        .background(Color.neutrals5)
                        .clipShape(Capsule())
                }
                .padding(.trailing, 10)
            }
        }
        
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("사진 삭제"),
                message: Text("선택한 사진을 삭제하겠산?"),
                primaryButton: .destructive(Text("삭제")) {
                    for photo in selectedPhotos {
                        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("LocalPhoto").appendingPathComponent(photo.filename)
                        try? FileManager.default.removeItem(at: url)
                    }
                    selectedPhotos.removeAll()
                    photos = PhotoManager.shared.loadAllPhotos()
                    
// ✅ 삭제 토스트 표시
                    showDeleteToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showDeleteToast = false
                    }
                    
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            photos = PhotoManager.shared.loadAllPhotos()
        }
        .sheet(isPresented: Binding(
            get: { isShareSheetPresented && !selectedPhotos.isEmpty },
            set: { newValue in
                if !newValue {
                    isShareSheetPresented = false
                    selectedPhotos.removeAll()
                    isSelectionMode = false
                }
            }
        ), onDismiss: {
            selectedPhotos.removeAll()
            isSelectionMode = false
        }) {
            let images = selectedPhotos.compactMap { PhotoManager.shared.loadImage(from: $0) }
            
            if !images.isEmpty {
                ShareSheet(activityItems: images)
            }
        }
    }
    
    @ViewBuilder
    private func imageCell(_ image: UIImage, _ photo: Photo? = nil) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(9/16, contentMode: .fit)
                .overlay(
                    isSelectionMode && photo != nil && selectedPhotos.contains(photo!)
                    ? Color.black.opacity(0.35)
                    : Color.clear
                )
                .onTapGesture {
                    guard let photo = photo else { return }
                    if isSelectionMode {
                        if selectedPhotos.contains(photo) {
                            selectedPhotos.remove(photo)
                        } else {
                            selectedPhotos.insert(photo)
                        }
                    } else {
                        coordinator.push(.photoDetailView(photo))
                    }
                }
            
            if isSelectionMode, let photo = photo {
                Image(systemName: selectedPhotos.contains(photo) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color("AccentColor"))
                    .padding(6)
            }
        }
    }
    
    
// ✅ 토스트 뷰
            @ViewBuilder
            private func toastView(text: String) -> some View {
                VStack {
                        Spacer()

                        HStack(spacing: 8) {
                            Image(systemName: "paperplane.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundColor(Color("AccentColor")) // 에셋 색상 사용
                            Text(text)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color("Neutrals2")) // 에셋 색상 사용
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

        #Preview {
            AlbumView()
        }
