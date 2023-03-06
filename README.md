

## **'WODI - 와디' - 2022.09.09 ~ 2022.10.14**

💪 크로스핏터들을 위한 운동(WOD)기록 어플리케이션

### 📈 판매량 - 아시아권 89.58%, 미국 및 캐나다 6.25%, 유럽 4.17% 

## **🏋️ 앱 소개**
- 캘린더를 통한 일 운동 여부 기록
- 운동종류별 기록 작성
- 1RM, 3RM, 5RM을 기반으로 한 무게 계산기
- 현 위치 기반으로 주변 체육관 탐색 및 체육관 정보 제공

## **📀 앱 시연 영상**
![고화질 와디](https://user-images.githubusercontent.com/81205931/207816102-7fd30ea2-c354-4370-83e1-3d83f373fd58.gif)

### **📱 기능 요약** 

- CodeBase로 **BaseView** 및 **BaseViewController** 클래스를 이용한 **모듈화** 및 뷰 구성
- Alamofire와 Kakao 검색 API를 사용하여 현 위치 **주변 체육관 검색 기능 구현**
- **Firebase Message**를 이용한 푸쉬 알람 보내기 기능 및 분기처리를 통한 foreground상태에서 **알람** 수신 허용
- 1RM, 3RM, 5RM을 기반으로 한 무게 계산기 기능 구현 및 종목 별 **Realm**을 통한Personal Record 기록 기능 구현
- **UISwipeGestureRecognizer**를 사용하여 달력을 주별 및 월별로 변경하는 기능 구현
- Realm을 통한 **Table**설계 및 **CRUD**구현
- MapKit의 Annotation을 통한 **체육관 시각화**
- **FSCalendar**를 통한 일 운동 여부 기록
- 운동 종류별 기록 작성 기능 구현
- 매일 오후 10시 운동 **리마인더 알람** 전송 기능

## **UI**
- ### ```CodeBaseUI```
## **Architecture**
- ### ```MVC``` 
##  **Framework & Library**
- ### ```UIKit```, ```MapKit```, ```CoreLocation```
- ### ```Alamofire```, ```SwiftJSON```,  ```Realm```, ```Firebase Crashlytics```, ```Firebase Analytics```, ```SnapKit```, ```FSCalendar```, ```Toast```, ```IQKeyboardManager``` 



## **Trouble Shooting**
### 두개의 테이블 연동, Array대신 List사용
- 고차함수를 사용해서 해결.
``` swift
class WODRealmTable: Object {
	//중략...
	
	@Persisted var workoutWithReps: List<Workout> = List<Workout>()
    var workoutWithRepsArray: [Workout] {
        get {
            return workoutWithReps.map { $0 }
        }
        set {
            workoutWithReps.removeAll()
            workoutWithReps.append(objectsIn: newValue)
        }
    }
	
	//중략...
}

class Workout: Object {
    @Persisted (primaryKey: true) var objectID: ObjectId
    @Persisted var workout: String = ""
    @Persisted var reps: Int = 0
}
```
### MapKit을 사용할때 사용자의 권한을 요청할때의 분기처리
- 설정앱으로 유도하는 부분을 url을 받아서 해결.
``` swift
func checkAppLocationAuth(authStatus: CLAuthorizationStatus) {
    switch authStatus {
        case .notDetermined:
        DispatchQueue.main.async {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    case .restricted, .denied:
        goToSettingAlert()
    case .authorizedWhenInUse:
        locationManager.startUpdatingLocation()
    default: print("DEFAULT")
}
// Alert를 사용해서 Setting으로 이동 
func goToSettingAlert() {
    let alert = UIAlertController(title: "설정앱으로가서 권한설정 해주세요", message: nil, preferredStyle: .alert)
    let action = UIAlertAction(title: "설정으로 가기", style: .destructive) {_ in
        let url = UIApplication.openSettingsURLString
        if let goSetting = URL(string: url) {
            UIApplication.shared.open(goSetting)
        }
    }
    let cancel = UIAlertAction(title: "취소", style: .default)
    alert.addAction(action)
    alert.addAction(cancel)
    present(alert, animated: true)
}
```


### **📝 출시 두달 후 회고**
익숙했던 TableView를 사용해서 뷰를 그린것이 조금 아쉬웠다. 비교적 최근에 나온 Modern Collection View Layout과 Diffable Datasource등을 사용해서 뷰를 그려봤다면 어땠을까 하는 생각이 든다.

앱 디자인을 해본적이 처음이었고 머리속에선 멋있다고 생각했던 뷰 들을 실제로 구현하는 과정에서 실제로 구현해보니 생각보다 별로여서 당황했었다. 또한 블로그에도 작성했지만 운동들을 제공해주는 API가 없어서 데이터들을 literal하게 작성했다는점이 아쉬웠다.

또한 MVC디자인 패턴을 차용했었는데 MVVM과 같은 새로운 디자인 패턴을 차용해서 컨트롤러가 비대해지고 의존도가 높아지는 문제를 해결했다면 어땠을까 하는 생각이든다.

### ___출시 이후___
현재는 리뷰들어온것 있으면 확인하고 피드백 받은 것들 위주로 업데이트를 하고 있다. 또한 출시하고 아쉬웠던 부분들에 대해서 업데이트를 진행하고 있다.

