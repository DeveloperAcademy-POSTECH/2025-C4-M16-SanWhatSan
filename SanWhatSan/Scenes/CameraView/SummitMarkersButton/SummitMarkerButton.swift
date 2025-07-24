//
//  SummitMarkerButton.swift
//  SanWhatSan
//
//  Created by Zhen on 7/24/25.
//

import SwiftUICore
import SwiftUI

struct SummitMarkerButton: View {
    var tmpImg = "tmp"
    var thumbImg: String?
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                .fill(Color.white.opacity(0.3))
                .frame(width: 55, height: 55)

            Image(thumbImg ?? tmpImg)
                .frame(width: 40, height: 40)
            
        }
    }
}


//struct SummitMarkerButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SummitMarkerButton(thumbImg: "tmp")
//    }
//}
