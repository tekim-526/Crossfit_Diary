//
//  BaseView.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/14.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeConstraints()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() { }
    func makeConstraints() { }
}
