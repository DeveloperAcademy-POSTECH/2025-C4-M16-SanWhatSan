//
//  Photo.swift
//  SanWhatSan
//
//  Created by 박난 on 7/21/25.
//

import SwiftUI

struct Photo: Identifiable, Hashable {
    let id: UUID
    let filename: String
    let savedDate: Date
    // TODO: 나중에 위도, 경도 값도 넣어야 함 - 산 위치값
    let location: Coordinate
}
