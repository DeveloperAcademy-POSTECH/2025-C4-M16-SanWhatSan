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
    let action: () -> Void

        var body: some View {
            Button(action: action) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)

                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(radius: 4)
            }
            .buttonStyle(PlainButtonStyle())
        }
}

#Preview {
    //MountainStackCardView()
}
