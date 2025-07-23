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

    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        if photos.isEmpty {
                            if let dummy = UIImage(named: "FakePhoto") {
                                imageCell(dummy)
                            }
                        } else {
                            ForEach(photos) { photo in
                                if let image = PhotoManager.shared.loadImage(from: photo) {
                                    imageCell(image, photo)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 10)
                }

                if isSelectionMode {
                    Divider()
                    HStack {
                        Button {
                            PhotoManager.shared.saveToPhotoLibrary(Array(selectedPhotos))
                            selectedPhotos.removeAll()
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                        }
                        .padding(.leading)

                        Spacer()

                        Text("\(selectedPhotos.count)장 선택됨")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Spacer()

                        Button {
                            isShareSheetPresented = true
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }

                        Button {
                            showDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .padding(.trailing)
                    }
                    .padding(.vertical, 12)
                    .background(Color(UIColor.systemGray6))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        coordinator.pop()
                    } label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.neutrals5)
                            .clipShape(Circle())
                    }
                }

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
                            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("MyAlbum").appendingPathComponent(photo.filename)
                            try? FileManager.default.removeItem(at: url)
                        }
                        selectedPhotos.removeAll()
                        photos = PhotoManager.shared.loadAllPhotos()
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                photos = PhotoManager.shared.loadAllPhotos()
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
                        coordinator.push(.photoDetailView(DisplayImage(id: UUID(), image: image)))
                    }
                }

            if isSelectionMode, let photo = photo {
                Image(systemName: selectedPhotos.contains(photo) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.blue)
                    .padding(6)
            }
        }
    }
}

#Preview {
    AlbumView()
}
