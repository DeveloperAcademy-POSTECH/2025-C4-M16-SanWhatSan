//
//  PhotoManager.swift
//  SanWhatSan
//
//  Created by 박난 on 7/21/25.
//

import UIKit
import Photos
import CoreLocation

class PhotoManager {
    static let shared = PhotoManager()
    private let folderName = "LocalPhoto"

    private var folderURL: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent(folderName)
    }

    init() {
        try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
    }

    func loadAllPhotos() -> [Photo] {
        let fileManager = FileManager.default
        guard let files = try? fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil) else {
            return []
        }

        let imageFiles = files.filter { $0.pathExtension == "jpg" }

        let photos: [Photo] = imageFiles.compactMap { imageURL in
            let idString = imageURL.deletingPathExtension().lastPathComponent
            let id = UUID(uuidString: idString) ?? UUID()

            let jsonURL = imageURL.deletingPathExtension().appendingPathExtension("json")

            var savedDate = Date()
            var coordinate = Coordinate(latitude: 35.8602, longitude: 128.5703) // default TODO: 나중에 수정
            
            if let data = try? Data(contentsOf: jsonURL),
               let meta = try? JSONDecoder().decode(PhotoMeta.self, from: data) {
                savedDate = meta.savedDate
                if let coord = meta.coordinate {
                    coordinate = coord
                }
            }

            return Photo(id: id, filename: imageURL.lastPathComponent, savedDate: savedDate, location: coordinate)
        }

        return photos.sorted { $0.savedDate > $1.savedDate }
    }


    func loadImage(from photo: Photo) -> UIImage? {
        let path = folderURL.appendingPathComponent(photo.filename)
        return UIImage(contentsOfFile: path.path)
    }
    
    func saveImageToLocalPhoto(_ image: UIImage, location: Coordinate? = nil) {
        let id = UUID()
        let filename = "\(id).jpg"
        let imageURL = folderURL.appendingPathComponent(filename)

        if let data = image.jpegData(compressionQuality: 0.9) {
            try? data.write(to: imageURL)

            let metadata = PhotoMeta(savedDate: Date(), coordinate: location)
            let metadataURL = folderURL.appendingPathComponent("\(id).json")

            if let jsonData = try? JSONEncoder().encode(metadata) {
                try? jsonData.write(to: metadataURL)
            }
        }
    }

    func saveToPhotoLibrary(_ photos: [Photo], location: CLLocation? = nil) {
        for photo in photos {
            if let image = loadImage(from: photo) {
                PHPhotoLibrary.shared().performChanges {
                    let request = PHAssetCreationRequest.forAsset()
                    if let data = image.jpegData(compressionQuality: 0.9) {
                        let options = PHAssetResourceCreationOptions()
                        request.addResource(with: .photo, data: data, options: options)
                    }
                    request.creationDate = photo.savedDate
                    request.location = location
                }
            }
        }
    }
    
    func loadRecentImage() -> UIImage {
        guard let recentPhoto = loadAllPhotos().first else {
            return UIImage()    // TODO: 갤러리에 아무것도 없을 때 기본 사진 추가
        }
        return loadImage(from: recentPhoto)!
    }
}
