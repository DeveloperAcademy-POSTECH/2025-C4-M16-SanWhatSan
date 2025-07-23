//
//  MountainStackCardView.swift
//  SanWhatSan
//
//  Created by Zhen on 7/8/25.
//

import SwiftUI

struct MountainStackCardView: View {
        let title: String
        let description: String
    let distance: Int
    let summitMarker: Int
    
    let action: () -> Void

        var body: some View {
//            Button(action: action) {
//                VStack(alignment: .leading, spacing: 8) {
//                    Text(title)
//                        .font(.title3)
//                        .fontWeight(.bold)
//
//                    Text(description)
//                        .font(.body)
//                        .foregroundColor(.secondary)
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color(.systemGray6))
//                .cornerRadius(16)
//                .shadow(radius: 4)
//            }
//            .buttonStyle(PlainButtonStyle())
            Button(action: action) {
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 1, height: 60)
                    

                    VStack(alignment: .leading, spacing: 6) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.black)
                        //TODO: 거리 계산 변수 추가
                        Text("\(distance) km | \(description)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        //TODO: 정상비 몇개 변수 추가
                        Text("정상비 \(summitMarker)개 있음")
                            .font(.caption)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.95))
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 4)
            }
            .padding(.horizontal, 20) // ← 여기가 핵심
        }
}

//#Preview {
//    MountainStackCardView(title: "봉좌산", description: "아", action: {
//        print("hi")
//    })
//}
