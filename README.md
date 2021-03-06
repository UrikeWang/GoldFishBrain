# GoldfishBrain

是一款針對使用者設定的目的地，進行地點偵測，等到使用者到達目的地時，會發送順利抵達目的地的訊息給親朋好友。
應用上的發想：
 - 設定目的地並發送通知給親朋好友，當安全抵達目的地時，則自動通知親朋好友
 - 設定目的地並發送通知給親朋好友，當使用者快抵達目的地時，則自動通知在目的地附近的親朋好友可以出發會合
 
### Notes
下載此專案後，請先申請GoogleMaps 與 GooglePlaces API Key並把以下兩個檔案補齊：
- GoogleService-Info.plist
  連結說明：https://support.google.com/firebase/answer/7015592?hl=zh-Hant

- Key.swift
  檔案格式如下：
  
  ```import Foundation```

  ```let servicesKey = "< Your GoogleMaps provideAPIKey>"```

  ```let placesClientKey = "<Your GooglePlaces provideAPIKey>"```

  ```var destinationCoordinates = [Double]()```

  ```var isNotified = [Int]()```

  ```var uid = UserDefaults.standard.value(forKey: "uid") as? String  ?? "" ```
 
## Features

- 使用者可以設定要通知的朋友
- 可以檢視之前的行程資料
- 被朋友設定為通知對象，將可以看到朋友的行程訊息
- 抵達目的地點時才會發送通知給朋友，不會有隱私的疑慮

## Libraries

- Firebase
- Crashlytics
- IQKeyboardManagerSwift
- GoogleMaps
- GooglePlaces
- GoogleMapsDirections
- NVActivityIndicatorView

## ScreenShot

### 新增行程

<p align="left">
  <img src="https://user-images.githubusercontent.com/28559402/30205626-ef9a6cfc-94bb-11e7-8e27-4ab9d6639e2e.PNG" width="250">
  <img src="https://user-images.githubusercontent.com/28559402/30205660-0e8efeac-94bc-11e7-811a-b7c10880eb32.PNG" width="250">
  <img src="https://user-images.githubusercontent.com/28559402/30206405-95db59ee-94be-11e7-9d7b-0f6adecb7b28.PNG" width="250">
</p>

### 行程新增後

- 與您選取朋友的聊天室中會有行程細節(左：您的畫面 / 右：朋友的畫面)
  <p align="left">
  <img src="https://user-images.githubusercontent.com/28559402/30206716-83e14770-94bf-11e7-9463-203d37b30445.PNG" width="250">
  <img src="https://user-images.githubusercontent.com/28559402/30206797-ccf1e988-94bf-11e7-9c8e-805d57ee33e6.PNG" width="250">
</p>

- 朋友的追蹤頁面
  <p align="left">
  <img src="https://user-images.githubusercontent.com/28559402/30208858-ea50910c-94c7-11e7-84d1-def86aa3c994.PNG" width="250">
</p>

- 取消行程時的頁面呈現
  <p align="left">
  <img src="https://user-images.githubusercontent.com/28559402/30208977-5da88e84-94c8-11e7-8a31-3878bb9ccf4c.PNG" width="250">
  <img src="https://user-images.githubusercontent.com/28559402/30208993-712ca814-94c8-11e7-81bd-4c7ff8ae9af3.PNG" width="250">
  <img src="https://user-images.githubusercontent.com/28559402/30209012-86740294-94c8-11e7-8367-c8b99cba2aed.PNG" width="250">
</p>

- 使用者抵達目的地時的頁面呈現
  <p align="left">
  <img src="https://user-images.githubusercontent.com/28559402/30210011-2ce005d4-94cd-11e7-8755-35ea25d52a27.PNG" width="250">
  <img src="" width="250">
</p>

## Requirement

- iOS 10.2+
- Xcode 8.3+
- Pod Install

## App Store

https://itunes.apple.com/us/app/id1273532360

## Contacts

Yu-Ling, Wang

takusax@gmail.com
