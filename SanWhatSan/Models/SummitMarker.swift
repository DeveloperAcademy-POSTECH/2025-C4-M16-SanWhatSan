//
//  SummitMarker.swift
//  SanWhatSan
//
//  Created by Zhen on 7/23/25.
//

import Foundation

struct SummitMarker {
    
    let modelFileName: String
    let textureFileName: String
    let overlayFileName: String
    let previewImageFileName: String
    
    //TODO: 산이 없을 때 default model 차후 모델 받으면 변경해야 함. 
    init(modelFileName: String, textureFileName: String, overlayFileName: String, previewImageFileName: String) {
        self.modelFileName = modelFileName
        self.textureFileName = textureFileName
        self.overlayFileName = overlayFileName
        self.previewImageFileName = previewImageFileName
    }
    
    init() {
        modelFileName = "sws_sanwhat.usd"
        textureFileName = "normalDX_sanwhat.jpg"
        overlayFileName = "uv_sanwhat.jpg"
        previewImageFileName = "산왔산"
    }
}
