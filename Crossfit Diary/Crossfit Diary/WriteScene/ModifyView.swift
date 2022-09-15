//
//  ModifyView.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/15.
//

import UIKit

class ModifyView: BaseView {
    
    
    let okButton: UIButton = {
        let view = UIButton()
        view.setTitle("확인", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        view.layer.cornerRadius = 15
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .systemOrange
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupUI() {
        self.layer.cornerRadius = 15
        [okButton].forEach { self.addSubview($0) }
    }
    override func makeConstraints() {
        let spacing = 16
        
        okButton.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
            make.height.equalTo(self.snp.height).multipliedBy(0.22)
        }
    }
    
}
