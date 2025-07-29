//
//  MountainListView.swift
//  SanWhatSan
//
//  Created by Zhen on 7/7/25.
//

import SwiftUI
import MapKit

struct MountainListView: View {
    
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @ObservedObject private var viewModel = MountainListViewModel()
    //지도 규모랑 중심. 여기서 수정하면 지도 규모 수정 가능.
    @State private var region = MKCoordinateRegion(
        center: .init(latitude: 36.0, longitude: 128.0),
        latitudinalMeters: 10_000,
        longitudinalMeters: 10_000
    )
    
    
    var body: some View {
        
        ZStack{
            //MARK: 지도
            MountainMapView(region: $region,
                            mountains: viewModel.closestMountains,
                            selectedMountain: viewModel.selectedMountain)
            .ignoresSafeArea(.all)
            
            //TODO: 이 그라데이션때문에 지도 터치가 안먹음. 우선순위 상의 후 Hifi 수정하거나 다른 방법을 찾아야 함.
            LinearGradient(
                colors: [
                    Color.white.opacity(0.8),
                    Color.white.opacity(0.2),
                    Color.white.opacity(0.0)
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()
            VStack{
                // MARK: 상단 바
                HStack {
                    
                    //MARK: 뒤로가기
                    Button(action: {
                        coordinator.pop()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .padding(.leading, 16)
                    Spacer()
                    //MARK: 현재 선택된 산은 ~
                    HStack(spacing:8){
                        ZStack{
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: .init(colors: [Color.accentColor.opacity(0.8), Color.accentColor.opacity(0.3)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 23, height: 23)
                            
                            Image(systemName: "mountain.2.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .foregroundColor(.white)
                        }
                        if let selected = viewModel.selectedMountain {
                            Text("현재 선택된 산은")
                                .font(Font.custom("Pretendard", size: 16))
                                .foregroundColor(.neutrals2)
                            Text("\(selected.name)")
                                .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                .bold()
                        }
                        else{
                            Text("현재 산이")
                                .font(Font.custom("Pretendard", size: 16))
                                .foregroundColor(.neutrals2)
                            Text("아니산!!")
                                .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                .foregroundColor(.accentColor)
                                .bold()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(20)
                    .fixedSize()
                    Spacer()
                    Spacer()

                }
                .padding(.top,8)
                Spacer()
                Spacer()
                Spacer()
                
                //MARK: ListCardView - 산이 없을 경우 스택을 보여주지 않기 때문에 (hifi 기준) 주석 처리 했습니다.
                VStack(spacing: 10){
                    if viewModel.closestMountains.isEmpty {
//                        Text("주변 100km 이내에 산이 없습니다 🏞️")
//                            .font(Font.custom("Pretendard", size: 16).weight(.bold))
//                            .background(Color.white)
//                            .cornerRadius(15)
                    }
                    else{
                        ForEach(viewModel.closestMountains) { mountain in
                            MountainStackCardView(
                                title: mountain.name,
                                description: "\(mountain.description)",
                                distance: mountain.distance,
                                summitMarker: mountain.summitMarkerCount
                            ) {
                                viewModel.manager.chosenMountain = mountain
                                coordinator.pop()
                            }   
                        }
                    }
                }
                
                
                
            }
            
        }
        .onChange(of: viewModel.closestMountains) { newList in
            if let first = newList.first {
                withAnimation {
                    region = MKCoordinateRegion(
                        center: first.coordinate.clLocationCoordinate2D,
                        span: MKCoordinateSpan(latitudeDelta: 0.3,
                                               longitudeDelta: 0.3)
                    )
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        //MARK: custom Alert
        .alert("위치 권한이 필요합니다", isPresented: $viewModel.shouldShowAlert){
            Button("OK", role: .cancel){}
        }
        //        .padding(.horizontal)
        //        .padding(.vertical)
        
    }
}


