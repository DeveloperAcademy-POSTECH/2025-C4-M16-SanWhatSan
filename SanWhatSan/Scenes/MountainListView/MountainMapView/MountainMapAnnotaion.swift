//
//  MountainMapAnnotaion.swift
//  SanWhatSan
//
//  Created by Zhen on 7/20/25.
//

import SwiftUI

struct MountainMapAnnotationView: View {
    let mountain: Mountain
    //let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(Color.brown)
                    .frame(width:27, height: 27)
                Image(systemName: "mountain.2.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 27, height: 27)
                    .foregroundColor(.white)
            }
            
            Text(mountain.name)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            // 네 방향으로 얇은 화이트 그림자 추가
                .shadow(color: .white, radius: 0, x: 1, y: 1)
                .shadow(color: .white, radius: 0, x: -1, y: -1)
                .shadow(color: .white, radius: 0, x: -1, y: 1)
                .shadow(color: .white, radius: 0, x: 1, y: -1)
        }
        .offset(y: -20)
    }
}

#Preview {
    //MountainMapAnnotationView(mountain: <#T##Mountain#>)
}
