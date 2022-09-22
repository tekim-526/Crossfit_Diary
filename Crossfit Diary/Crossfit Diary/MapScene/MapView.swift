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
    
    let annotationDetailLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        
        label.backgroundColor = .systemBackground
        label.textAlignment = .center

        label.layer.cornerRadius = 20
        label.numberOfLines = 3
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 4)
        label.layer.shadowRadius = 3
        label.layer.shadowOpacity = 0.2
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
        [map, annotationDetailLabel].forEach { self.addSubview($0) }
    }
    override func makeConstraints() {
        
        map.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        annotationDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.leading.equalTo(12)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.height.equalTo(self.snp.height).multipliedBy(0.1)
        }
    }
}
