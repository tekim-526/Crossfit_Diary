//
//  WritePRView.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/10/05.
//

import UIKit
import SnapKit

class WritePRView: BaseView {
    
    
    let oneRMTextField: UITextField = { return UITextField().customTextField() }()
    let oneRMLabel: UILabel = { return UILabel().rmLabel(title: "1RM") }()
    
    let threeRMTextField: UITextField = { return UITextField().customTextField() }()
    let threeRMLabel: UILabel = { return UILabel().rmLabel(title: "3RM") }()
    
    let fiveRMTextField: UITextField = { return UITextField().customTextField() }()
    let fiveRMLabel: UILabel = { return UILabel().rmLabel(title: "5RM") }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3
        button.backgroundColor = .mainColor
        let attributedString = NSMutableAttributedString(string: "저장", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold)])
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    let segmentControl: UISegmentedControl = {
        let segItems = ["1RM", "3RM", "5RM"]
        let seg = UISegmentedControl(items: segItems)
        seg.tintColor = .mainColor
        seg.selectedSegmentTintColor = .mainColor
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .bold)], for: .normal)
        return seg
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        self.backgroundColor = .systemBackground
        [oneRMLabel, oneRMTextField, threeRMLabel, threeRMTextField, fiveRMLabel, fiveRMTextField, saveButton, segmentControl].forEach { self.addSubview($0) }
    }
    
    override func makeConstraints() {
        constraintsBetweenTfAndLabel(tf: oneRMTextField, label: oneRMLabel, self.snp.leading)
        constraintsBetweenTfAndLabel(tf: threeRMTextField, label: threeRMLabel, oneRMTextField.snp.trailing)
        constraintsBetweenTfAndLabel(tf: fiveRMTextField, label: fiveRMLabel, threeRMLabel.snp.trailing)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(threeRMLabel.snp.bottom).offset(12)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(36)
        }
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(20)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(28)
        }
    }
}

extension WritePRView {
    func constraintsBetweenTfAndLabel(tf: UITextField,
                                      label: UILabel,
                                      _ leading: ConstraintRelatableTarget) {
        let top: CGFloat = 12
        let tfHeight: CGFloat = 36
        let labelHeight: CGFloat = 28
        tf.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(top)
            make.leading.equalTo(leading)
            make.width.equalTo(self.snp.width).multipliedBy(0.333)
            make.height.equalTo(tfHeight)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(tf.snp.bottom)
            make.centerX.equalTo(tf.snp.centerX)
            make.width.equalTo(self.snp.width).multipliedBy(0.333)
            make.height.equalTo(labelHeight)
        }
    }
}
