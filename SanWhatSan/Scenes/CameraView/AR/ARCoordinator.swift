//
//  ARCoordinator.swift
//  SanWhatSan
//
//  Created by 박난 on 7/10/25.
//

import SwiftUI
import ARKit

class ARCoordinator: NSObject, ARSessionDelegate {
    weak var manager: ARManager?
    
    init(_ manager: ARManager) {
        self.manager = manager
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // TODO: 필요 시 프레임 기반 정보 업데이트
    }
}

