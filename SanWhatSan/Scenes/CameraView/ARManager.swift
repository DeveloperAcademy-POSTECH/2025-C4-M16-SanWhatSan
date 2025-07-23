//
//  ARManager.swift
//  SanWhatSan
//
//  Created by 박난 on 7/10/25.
//
import SwiftUI
import ARKit
import RealityKit

class ARManager {
    var arView: ARView?
    lazy var coordinator = ARCoordinator(self)
    
    func setupARView() -> ARView {
        let view = ARView(frame: .zero)
        arView = view
        view.session.delegate = coordinator

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        
        // LiDAR 기반 지면 재구성 (Scene Mesh + 분류 포함)
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) {
            config.sceneReconstruction = .meshWithClassification
        } else {
            print("이 기기는 LiDAR 기반 재구성을 지원하지 않습니다.")
        }

        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            config.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        view.renderOptions.remove(.disablePersonOcclusion)

        view.session.run(config)

//        view.debugOptions = [.showFeaturePoints, .showWorldOrigin, .showAnchorOrigins]

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)

        return view
    }

    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let view = arView else { return }
        let location = sender.location(in: view)
        
        placeModel(at: location)
    }

    func startSession() {
        guard let arView else { return }

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic

        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) {
            config.sceneReconstruction = .meshWithClassification
        }

        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            config.frameSemantics.insert(.personSegmentationWithDepth)
        }

        arView.renderOptions.remove(.disablePersonOcclusion)

        arView.session.run(config)
    }


    func placeModel(at point: CGPoint) {
        guard let arView,
              let rayResult = arView.raycast(from: point, allowing: .estimatedPlane, alignment: .horizontal).first else {
            print("Raycast 실패")
            return
        }

        let anchor = AnchorEntity(world: rayResult.worldTransform)

        do {
            // 모델 불러오기
            let model = try Entity.loadModel(named: "sws2.usd")

            // 텍스처 불러오기
            let baseColorTexture = try TextureResource.load(named: "uv2.jpg")
            let normalMapTexture = try TextureResource.load(named: "normalDX2.jpg")

            // 머티리얼 생성
            var material = PhysicallyBasedMaterial()
            material.baseColor.texture = .init(baseColorTexture)
            material.normal.texture = .init(normalMapTexture)
            material.roughness.scale = 1.0  // 선택적 설정
            material.metallic.scale = 5.0   // 선택적 설정

            // 모델 엔티티로 캐스팅 및 머티리얼 적용
            if let modelEntity = model as ModelEntity? {
                modelEntity.model?.materials = [material]
                modelEntity.generateCollisionShapes(recursive: true)

                // 모델 높이 보정 (지면에 붙게)
                let bounds = modelEntity.visualBounds(relativeTo: nil)
                modelEntity.position.y -= bounds.min.y

                anchor.addChild(modelEntity)
            } else {
                anchor.addChild(model)  // fallback
            }

            // 기존 앵커 제거 후 새로 추가
            arView.scene.anchors.removeAll()
            arView.scene.anchors.append(anchor)

        } catch {
            print("모델 또는 텍스처 로딩 실패: \(error)")
        }
    }


    func captureSnapshot(completion: @escaping (UIImage?) -> Void) {
        arView?.snapshot(saveToHDR: false, completion: completion)
    }
}
