//
//  MapView.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/20.
//

import UIKit
import MapKit
import SnapKit

class MapView: BaseView {
    lazy var map: MKMapView = {
        let map = MKMapView(frame: self.frame)
        return map
    }()
    
    lazy var annotationDetailView: UIView = {
        let view = UIView()
        view.addSubview(annotationDetailLabel)
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.isHidden = true
        return view
    }()
    
    lazy var annotationDetailLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupUI() {
        self.backgroundColor = .systemBackground
        [map, annotationDetailView].forEach { self.addSubview($0) }
    }
    override func makeConstraints() {
        
        map.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        annotationDetailView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-12)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(self.snp.height).multipliedBy(0.1)
        }
        annotationDetailLabel.snp.makeConstraints { make in
            make.edges.equalTo(self.annotationDetailView.snp.edges).inset(12)
        }
    }
}
