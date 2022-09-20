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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupUI() {
        self.backgroundColor = .systemBackground
        self.addSubview(map)
    }
    override func makeConstraints() {
        map.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
