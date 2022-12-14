# Crossfit_Diary

## **WODI - 와디**
### 2022.09.09 ~ 2022.10.14 (개선 중)

### 💪 크로스핏터들을 위한 운동(WOD)기록 어플리케이션

### 📈 판매량 - 아시아권 89.58%, 미국 및 캐나다 6.25%, 유럽 4.17% 

### **🏋️ 앱 소개**
- 캘린더를 통한 일 운동 여부 기록
- 운동종류별 기록 작성
- 1RM, 3RM, 5RM을 기반으로 한 무게 계산기
- 현 위치 기반으로 주변 체육관 탐색 및 체육관 정보 제공

### **📱 담당한 부분** 

- 기획 전체 & 디자인 전체
- Alamofire와 카카오 검색 API를 사용한 주변 박스 위치 및 정보 가져오는 기능 
- MapKit과 핀 어노테이션을 통한 현 위치 주변 체육관 시각화
- Realm을 사용한 Table설계 및 운동 기록 및 1RM, 3RM, 5RM 데이터 저장
- Firebase Analytics & Crashlytics를 통한 실시간 피드백 및 Crash log 확인
- FSCalendar와 Realm연동을 통한 당일 운동 여부 확인
- TableView를 사용한 모든 뷰 구성
- 매일 오후10시 로컬 푸쉬 알림기능 구성
- APNs와 Firebase를 사용한 푸쉬 알림 기능 

### **📌 사용한 기술**

- UIKit
- MapKit
- CoreLocation
- Alamofire
- SwiftyJSON
- Firebase
- FSCalendar
- Realm
- SnapKit
- Toast
- IQKeyboardManager

### **📝 출시 두달 후 회고**
익숙했던 TableView를 사용해서 뷰를 그린것이 조금 아쉬웠다. 비교적 최근에 나온 Modern Collection View Layout과 Diffable Datasource등을 사용해서 뷰를 그려봤다면 어땠을까 하는 생각이 든다.

앱 디자인을 해본적이 처음이었고 머리속에선 멋있다고 생각했던 뷰 들을 실제로 구현하는 과정에서 실제로 구현해보니 생각보다 별로여서 당황했었다. 또한 블로그에도 작성했지만 운동들을 제공해주는 API가 없어서 데이터들을 literal하게 작성했다는점이 아쉬웠다.

### ___어려웠던 점___
앱을 만들면서 가장 어려웠던 점은 실제 프로젝트에 적용해보는 Realm이었던것 같다. 두개의 Table 연동이라던지 Realm에는 Array사용이 안되고 List사용을 해야하는데 어떻게 사용하는지 몰라서 애먹었었던 것 같다. 하단의 코드 몇줄 작성하는데 시간을 굉장히 많이 썼다. 또한 마이그레이션을 어떻게 하는지 몰라서 애먹었던 기억도 난다.

``` swift
class WODRealmTable: Object {
	////중략
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
	////중략
}

class Workout: Object {
    @Persisted (primaryKey: true) var objectID: ObjectId
    @Persisted var workout: String = ""
    @Persisted var reps: Int = 0
}
```
다음으로 어려웠던 점은 TableView의 높이를 지정하는 과정에서 TableView의 automaicDemension을 어떻게 주는지 몰라서 높이지정하는데 애먹었다.

### ___출시 이후___
현재는 리뷰들어온거 있으면 확인하고 피드백 받은 것들 위주로 업데이트를 하고 있다. 또한 출시하고 아쉬웠던 부분들에 대해서 업데이트를 진행하고 있다.

