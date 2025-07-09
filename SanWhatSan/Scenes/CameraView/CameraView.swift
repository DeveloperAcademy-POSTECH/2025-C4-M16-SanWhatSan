//
//  CameraView.swift
//  SanWhatSan
//
//  Created by Zhen on 7/7/25.
//

import SwiftUI

struct CameraView: View {
    var body: some View {
        
        
        
        NavigationStack{
            VStack{
                
                Text("CameraView").font(.title)
                    .padding(20)
                
                
                NavigationLink{
                    MountainListView()
                } label: {
                    Text("다른 산으로 이동")
                        .padding(10)
                }

                NavigationLink{
                    ImageView(
                        image: UIImage(named: "FakePhoto")!, // 임시 이미지로 Assets에 있는 FakePhoto 사용함
                        //image: UIImage(systemName: "photo")!, // 임시 이미지
                        onRetake: {}
                        )
                } label: {
                    Text("이미지뷰로 이동")
                        .padding(10)
                }
                
               
            }
        }
    }
}

#Preview {
    CameraView()
}
