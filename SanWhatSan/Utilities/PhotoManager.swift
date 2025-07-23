//
//  PhotoManager.swift
//  SanWhatSan
//
//  Created by 박난 on 7/21/25.
//

import Foundation
import CoreLocation
import UIKit
import Photos

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

        return files.compactMap { url in
            let id = UUID(uuidString: url.deletingPathExtension().lastPathComponent) ?? UUID()
            return Photo(id: id, filename: url.lastPathComponent, savedDate: Date(), location: Coordinate(latitude: 35.8602, longitude: 128.5703))
        }
    }

    func loadImage(from photo: Photo) -> UIImage? {
        let path = folderURL.appendingPathComponent(photo.filename)
        return UIImage(contentsOfFile: path.path)
    }
    
    func saveImageToLocalPhoto(_ image: UIImage) {
        let id = UUID()
        let filename = "\(id).jpg"
        let url = folderURL.appendingPathComponent(filename)
        if let data = image.jpegData(compressionQuality: 0.9) {
            try? data.write(to: url)
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
}
