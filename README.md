# 🏔 산왔산 (SanWhatSan) 

## 1️⃣ 프로젝트 개요

### 📖 프로젝트 소개

**목적**  
등산을 하는 사용자가 방문한 산의 **어디서든** 정상석과 사진을 찍을 수 있는 경험을 제공하자 ! 

**주요 기능**
- ✅ 기능 1: 위치 기반 산 리스트 제공
- ✅ 기능 2: AR 정상석 모델 표시
- ✅ 기능 3: 사진 촬영 및 저장, 공유


## 2️⃣ 참여 인원

| [<img src="https://github.com/whalswjd.png" width="80"/>](https://github.com/whalswjd) | [<img src="https://github.com/nan-park.png" width="80"/>](https://github.com/nan-park) | [<img src="https://github.com/simi-sumin.png" width="80"/>](https://github.com/simi-sumin) |
|:--:|:--:|:--:|
| **MINJEONG** <br> | **NanPark** <br> | **simi-sumin** <br> |

| [<img src="https://github.com/1ONE111.png" width="80"/>](https://github.com/1ONE111) | [<img src="https://github.com/Junia-Choi.png" width="80"/>](https://github.com/Junia-Choi) | [<img src="https://github.com/gun-no.png" width="80"/>](https://github.com/gun-no) |
|:--:|:--:|:--:|
| **hONE (Ell)** <br> | **Junia-Choi** <br> | **gun-no** <br> |

## 3️⃣ 프로젝트 구조 설명

```plaintext
SanWhatSan/
├── App/
├── Models/              
├── Navigation/                 
├── Preview Content/
├── Resources/
├── Scenes/
├── Service/
├── Utilities/
└── Info.plist               
```

## 4️⃣ 개발 환경 설정

### 🛠 환경 설정 가이드

- macOS: Ventura 이상 권장
- Xcode: 15.0 이상
- iOS Deployment Target: iOS 17.0 이상
- Swift: 5.9+
- 필수 설정:
  - **카메라 권한 (ARKit)** 및 **위치 권한 (CoreLocation)** 설정 필요
  - 실제 기기에서 실행 필요 (ARKit 사용 시 시뮬레이터 동작 불가)
