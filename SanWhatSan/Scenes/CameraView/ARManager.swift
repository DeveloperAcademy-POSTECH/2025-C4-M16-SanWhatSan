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
    private var lastScale: Float = 1.0
    var marker: SummitMarker?
    
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
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        view.addGestureRecognizer(pinchGesture)

        return view
    }

    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let view = arView else { return }
        let location = sender.location(in: view)
        
        placeModel(at: location)
    }
    
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let arView = arView else { return }

        // 현재 씬에서 첫 번째 Anchor의 첫 번째 자식 모델을 대상으로 한다고 가정
        guard let anchor = arView.scene.anchors.first,
              let model = anchor.children.first as? ModelEntity else { return }

        switch gesture.state {
        case .began:
            lastScale = model.scale.x  // 현재 스케일 저장
        case .changed:
            let scaleFactor = Float(gesture.scale)
            let newScale = lastScale * scaleFactor
            model.setScale([newScale, newScale, newScale], relativeTo: nil)
        default:
            break
        }
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
            //TODO: 바닥면을 인식하지 못했습니다.
            return
        }

        let anchor = AnchorEntity(world: rayResult.worldTransform)

        do {
            if marker == nil {
                marker = SummitMarker()
            }
            guard let marker else { print("ARManager/placeModel: marker is nil"); return }
            
            // 모델 불러오기
            let model = try Entity.loadModel(named: marker.modelFileName)

            // 텍스처 불러오기
            let baseColorTexture = try TextureResource.load(named: marker.overlayFileName)
            let normalMapTexture = try TextureResource.load(named: marker.textureFileName)

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
    
    func removeModelInScene() {
        guard let arView else { return }
        arView.scene.anchors.removeAll()
    }
}
