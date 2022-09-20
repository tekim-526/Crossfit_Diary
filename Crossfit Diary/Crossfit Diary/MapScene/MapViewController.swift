//
//  MapViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/09.
//

import UIKit

import CoreLocation
import MapKit

class MapViewController: BaseViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var mapView = MapView()
    
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.map.delegate = self
        locationManager.delegate = self
        checkDeviceLocationAuth()
        mapView.map.showsUserLocation = true
        mapView.map.setUserTrackingMode(.follow, animated: true)
    }
    
    // MARK: - Methods
    func mapViewSetUp(center: CLLocationCoordinate2D) {

        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        mapView.map.setRegion(region, animated: true)
    }
    
    func checkDeviceLocationAuth() {
        let authStatus: CLAuthorizationStatus
        if CLLocationManager.locationServicesEnabled() {
            // 기기 위치설정이 되어 있으므로 앱 설정 체크
            if #available(iOS 14.0, *) {
                authStatus = locationManager.authorizationStatus
            } else {
                authStatus = CLLocationManager.authorizationStatus()
            }
            checkAppLocationAuth(authStatus: authStatus)
        } else {
            showAlert()
            // 기기 위치설정 안되있는 경우 -> Alert 띄우고 설정으로 유도
        }
    }
    
    func checkAppLocationAuth(authStatus: CLAuthorizationStatus) {
        switch authStatus {
        case .notDetermined:
            print("notDetermined")
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            }
        case .restricted, .denied:
            // 아이폰 설정으로 유도
            print("denied")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            locationManager.startUpdatingLocation()
        default: print("DEFAULT")
        }
    }

    func showAlert() {
        let alert = UIAlertController(title: "권한 주세요", message: nil, preferredStyle: .alert)
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

    func makeAnnotation(longitudeX: String, latitudeY: String, placeName: String) {
        let annotation = MKPointAnnotation()
        let x = CLLocationDegrees(floatLiteral: Double(longitudeX) ?? 0.0)
        let y = CLLocationDegrees(floatLiteral: Double(latitudeY) ?? 0.0)
        annotation.coordinate = CLLocationCoordinate2DMake(y, x)
        annotation.title = placeName
        
        mapView.map.addAnnotation(annotation)
    }
    
}
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//       locationManager.stopUpdatingLocation()
    }
}

extension MapViewController {
    // 현재 위치
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            mapViewSetUp(center: coordinate)
            KakaoSearchAPIManager.kakaoSearchPlace(searchName: "크로스핏", x: coordinate.longitude, y: coordinate.latitude) { placeList in
                for i in 0...placeList.count - 1 {
                    self.makeAnnotation(longitudeX: placeList[i].longitudeX, latitudeY: placeList[i].latitudeY, placeName: placeList[i].placeName)
                }
            }
        }
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuth()
    }
}
