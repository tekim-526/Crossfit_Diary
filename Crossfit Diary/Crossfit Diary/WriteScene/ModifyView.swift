//
//  ModifyView.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/15.
//

import UIKit

class ModifyView: BaseView {
    
    let workoutLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let repsTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 16, weight: .black)
        tf.textAlignment = .center
        tf.placeholder = "횟수를 입력해 주세요"
        return tf
    }()
    
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
        [workoutLabel, repsTextField, okButton].forEach { self.addSubview($0) }
    }
    override func makeConstraints() {
        let spacing = 12
        workoutLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.leading.equalTo(spacing)
            make.trailing.equalTo(-spacing)
            make.height.equalTo(20)
        }
        repsTextField.snp.makeConstraints { make in
            make.top.equalTo(workoutLabel.snp.bottom).offset(spacing)
            make.leading.equalTo(spacing)
            make.trailing.equalTo(-spacing)
            make.height.equalTo(20)
        }
        okButton.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
            make.height.equalTo(self.snp.height).multipliedBy(0.2)
        }
    }
    
}
