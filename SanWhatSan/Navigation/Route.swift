//
//  Route.swift
//  SanWhatSan
//
//  Created by 박난 on 7/10/25.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case cameraView
    case mountainListView(MountainListViewModel)
    case albumView
    case photoDetailView(Photo)
//    case frameView   
}
