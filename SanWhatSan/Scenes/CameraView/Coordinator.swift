//
//  Coordinator.swift
//  SanWhatSan
//
//  Created by 박난 on 7/9/25.
//

import SwiftUI
import RealityKit
import ARKit

class Coordinator: NSObject, ARSessionDelegate, ObservableObject {
    var arView: ARView?
    var hasPlacedModel = false

    func placeModel() {
        guard let arView = arView,
              let cameraTransform = arView.session.currentFrame?.camera.transform else { return }

        let cameraPosition = SIMD3<Float>(cameraTransform.columns.3.x,
                                           cameraTransform.columns.3.y,
                                           cameraTransform.columns.3.z)

        let forward = -normalize(SIMD3<Float>(cameraTransform.columns.2.x,
                                              cameraTransform.columns.2.y,
                                              cameraTransform.columns.2.z))

        let rayOrigin = cameraPosition
        let rayDirection = forward

        let raycastQuery = ARRaycastQuery(origin: rayOrigin,
                                          direction: rayDirection,
                                          allowing: .estimatedPlane,
                                          alignment: .horizontal)

        if let result = arView.session.raycast(raycastQuery).first {
            let position = result.worldTransform

            if let existingAnchors = arView.scene.anchors.first {
                arView.scene.anchors.remove(existingAnchors)
            }

            do {
                let model = try Entity.loadModel(named: "sws1.usd")

                let bounds = model.visualBounds(relativeTo: nil)
                let minY = bounds.min.y
                model.position.y -= minY

                let anchor = AnchorEntity(world: position)
                anchor.addChild(model)
                arView.scene.anchors.append(anchor)

                hasPlacedModel = true
            } catch {
                print("모델 로드 실패: \(error)")
            }
        } else {
            print("바닥을 찾을 수 없습니다.")
        }
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
    }
    
    func captureSnapshot(completion: @escaping (UIImage?) -> Void) {
        guard let arView = arView else {
            completion(nil)
            return
        }

        arView.snapshot(saveToHDR: false) { image in
            completion(image)
        }
    }

}
