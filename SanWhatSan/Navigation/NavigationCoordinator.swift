//
//  NavigationCoordinator.swift
//  SanWhatSan
//
//  Created by 박난 on 7/10/25.
//

import Foundation

class NavigationCoordinator: ObservableObject {
    @Published var path: [Route] = []

    func push(_ path: Route) {
        self.path.append(path)
    }

    func pop() {
        self.path.removeLast()
    }

    func popToRoot() {
        self.path.removeAll()
    }
}
