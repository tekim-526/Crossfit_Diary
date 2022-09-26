//
//  WriteView.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/09.
//

import UIKit
import SnapKit

class WriteView: BaseView {
    
    // MARK: - Properties
    // weight TextField & Label
    let barbellTextField: UITextField = { return UITextField().customTextField() }()
    let barbellLabel: UILabel = { return UILabel().customLabel(weightKind: "바벨", unit: "lb") }()
    
    let dumbellTextField: UITextField = { return UITextField().customTextField() }()
    let dumbellLabel: UILabel = { return UILabel().customLabel(weightKind: "덤벨", unit: "lb") }()

    let kettlebellTextField: UITextField = { return UITextField().customTextField() }()
    let kettlebellLabel: UILabel = { return UILabel().customLabel(weightKind: "케틀벨", unit: "kg") }()

    let medicineBallTextField: UITextField = { return UITextField().customTextField() }()
    let medicineBallLabel: UILabel = { return UILabel().customLabel(weightKind: "메디신볼", unit: "lb") }()

    let weightedVestTextField: UITextField = { return UITextField().customTextField() }()
    let weightedVestLabel: UILabel = { return UILabel().customLabel(weightKind: "중량조끼", unit: "kg") }()
    
    // Team StackView
    let teamTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "n"
        tf.keyboardType = .numberPad
        tf.font = .systemFont(ofSize: 16, weight: .bold)
        return tf
    }()
    let teamLabel: UILabel = {
        let label = UILabel()
        label.text = "Team of"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    lazy var teamStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.addArrangedSubview(teamLabel)
        stackView.addArrangedSubview(teamTextField)
        return stackView
    }()
    
    // kind of WOD StackView
    let kindOfWODLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.text = "AMRAP"
        return label
    }()
    let minuteTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "min"
        tf.textAlignment = .center
        tf.keyboardType = .numberPad
        tf.font = .systemFont(ofSize: 16, weight: .bold)
        return tf
    }()
    let minuteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "minutes"
        label.textAlignment = .left
        return label
    }()
    lazy var kindOfWODStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.addArrangedSubview(kindOfWODLabel)
        stackView.addArrangedSubview(minuteTextField)
        stackView.addArrangedSubview(minuteLabel)
        return stackView
    }()
    
    // additional TextView -> WriteVC에서 델리게이트 필요 플레이스 홀더 넣기 위함
    let additionalTextView: UITextView = {
        let tv = UITextView()
        tv.textAlignment = .center
        tv.layer.borderWidth = 1.0
        tv.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        tv.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        tv.font = .systemFont(ofSize: 16, weight: .bold)
        return tv
    }()
    
    // tableView
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        self.backgroundColor = .systemBackground
        [barbellTextField, barbellLabel, dumbellTextField, dumbellLabel, kettlebellTextField,
         kettlebellLabel, medicineBallTextField, medicineBallLabel, weightedVestTextField,
         weightedVestLabel, teamStackView, kindOfWODStackView, additionalTextView, tableView]
            .forEach { self.addSubview($0) }
    }
    override func makeConstraints() {
        let topPadding: CGFloat = 12
        let tfHeight: CGFloat = 36
        let labelHeight: CGFloat = 56
        let safeArea = self.safeAreaLayoutGuide
        constraintsBetweenTfAndLabel(tf: barbellTextField, label: barbellLabel, safeArea, self.snp.leading, topPadding: topPadding, tfHeight: tfHeight, labelHeight: labelHeight)
        constraintsBetweenTfAndLabel(tf: dumbellTextField, label: dumbellLabel, safeArea, barbellLabel.snp.trailing, topPadding: topPadding, tfHeight: tfHeight, labelHeight: labelHeight)
        constraintsBetweenTfAndLabel(tf: kettlebellTextField, label: kettlebellLabel, safeArea, dumbellLabel.snp.trailing, topPadding: topPadding, tfHeight: tfHeight, labelHeight: labelHeight)
        constraintsBetweenTfAndLabel(tf: medicineBallTextField, label: medicineBallLabel, safeArea, kettlebellLabel.snp.trailing, topPadding: topPadding, tfHeight: tfHeight, labelHeight: labelHeight)
        constraintsBetweenTfAndLabel(tf: weightedVestTextField, label: weightedVestLabel, safeArea, medicineBallLabel.snp.trailing, topPadding: topPadding, tfHeight: tfHeight, labelHeight: labelHeight)
        
        teamStackView.snp.makeConstraints { make in
            make.top.equalTo(kettlebellLabel.snp.bottom).offset(4)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width).multipliedBy(0.21)
            make.height.equalTo(32)
        }
        kindOfWODStackView.snp.makeConstraints { make in
            make.top.equalTo(teamStackView.snp.bottom)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width).multipliedBy(0.44)
            make.height.equalTo(32)
        }
        additionalTextView.snp.makeConstraints { make in
            make.top.equalTo(kindOfWODStackView.snp.bottom).offset(4)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(self.snp.width).multipliedBy(0.9)
            make.height.equalTo(68)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(additionalTextView.snp.bottom).offset(4)
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}

extension WriteView {
    func constraintsBetweenTfAndLabel(tf: UITextField,
                                      label: UILabel,
                                      _ top: ConstraintRelatableTarget,
                                      _ leading: ConstraintRelatableTarget,
                                      topPadding: CGFloat,
                                      tfHeight: CGFloat,
                                      labelHeight: CGFloat) {
        tf.snp.makeConstraints { make in
            make.top.equalTo(top).offset(topPadding)
            make.leading.equalTo(leading)
            make.width.equalTo(self.snp.width).multipliedBy(0.2)
            make.height.equalTo(tfHeight)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(tf.snp.bottom)
            make.centerX.equalTo(tf.snp.centerX)
            make.width.equalTo(self.snp.width).multipliedBy(0.2)
            make.height.equalTo(labelHeight)
        }
    }
}

extension UITextField {
    func customTextField() -> UITextField {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 18, weight: .black)
        tf.textColor = .label
        tf.attributedPlaceholder = NSAttributedString(string: "--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.label])
        tf.textAlignment = .center
        tf.keyboardType = .numberPad
        tf.resignFirstResponder()
        return tf
    }
}
extension UILabel {
    func customLabel(weightKind: String, unit: String) -> UILabel {
        let label = UILabel()
        label.text = weightKind + "\n" + "(\(unit))"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }
}
