//
//  MapViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/09.
//

import UIKit

import CoreLocation
import MapKit
import SnapKit

class MapViewController: BaseViewController, CLLocationManagerDelegate {
    var mapView = MapView()
    var locationManager = CLLocationManager()
    var authStatus: CLAuthorizationStatus!
    var placeList: [Place]!
    
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
        
        view.backgroundColor = .mainColor
    }
    
    // MARK: - Methods
    func mapViewSetUp(center: CLLocationCoordinate2D) {

        let region = MKCoordinateRegion(center: center, latitudinalMeters: 3000, longitudinalMeters: 300)
        mapView.map.setRegion(region, animated: true)
    }
    
    func checkDeviceLocationAuth() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                if #available(iOS 14.0, *) {
                    self.authStatus = self.locationManager.authorizationStatus
                } else {
                    self.authStatus = CLLocationManager.authorizationStatus()
                }
                self.checkAppLocationAuth(authStatus: self.authStatus)
            } else {
                self.showAlert(title: "기기 위치권한 설정이 되어있지 않습니다.", message: "설정 -> 개인정보 보호 및 보안 -> 위치서비스로 가셔서 권한을 허용해 주세요.")
            }
        }
    }
    
    func checkAppLocationAuth(authStatus: CLAuthorizationStatus) {
        switch authStatus {
        case .notDetermined:
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.startUpdatingLocation()
            }
        case .restricted, .denied:
            // 아이폰 설정으로 유도
            print("denied")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default: print("DEFAULT")
        }
    }

    func makeAnnotation(place: Place) {
        let annotation = MKPointAnnotation()
        let x = CLLocationDegrees(floatLiteral: Double(place.longitudeX) ?? 0.0)
        let y = CLLocationDegrees(floatLiteral: Double(place.latitudeY) ?? 0.0)
        annotation.coordinate = CLLocationCoordinate2DMake(y, x)
        annotation.title = place.placeName
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
            mapView.map.removeAnnotations(mapView.map.annotations)
            KakaoSearchAPIManager.kakaoSearchPlace(searchName: "크로스핏", x: coordinate.longitude, y: coordinate.latitude) { placeList in
                for i in 0...placeList.count - 1 {
                    self.makeAnnotation(place: placeList[i])
                }
                self.placeList = placeList
            }
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuth()
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation?.title == "My Location" {
            self.mapView.annotationDetailView.isHidden = true
            return
        }
        for place in placeList {
            if let annotation = view.annotation, place.placeName == annotation.title  {
                makeAttributedLabel(label: self.mapView.annotationDetailLabel, first: place.placeName, second: place.roadAdressName, third: place.phone)
            }
        }
        self.mapView.annotationDetailView.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.mapView.annotationDetailView.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            annotationView?.annotation = annotation
        }
        
        let mappinImage = UIImage(named: "mappin")
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContext(size)
        mappinImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        
        let annotationLabel = UILabel(frame: CGRect(x: -20, y: 40, width: 80, height: 30))
        annotationLabel.numberOfLines = 1
        annotationLabel.textAlignment = .center
        annotationLabel.font = .systemFont(ofSize: 10, weight: .bold)
        annotationLabel.text = annotation.title as? String
        annotationView?.addSubview(annotationLabel)

        return annotationView
    }
    
    func makeAttributedLabel(label: UILabel, first: String, second: String, third: String?) {
        let attributedTitle = NSMutableAttributedString(string: first + "\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold)])
        attributedTitle.append(NSAttributedString(string: second + "\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .regular)]))
        guard let third else {
            label.attributedText = attributedTitle
            return
        }
        attributedTitle.append(NSAttributedString(string: third == "" ? "연락처 정보 없음" : third, attributes: [NSAttributedString.Key.foregroundColor : UIColor.tintColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .regular)]))
        label.attributedText = attributedTitle
    }
}
