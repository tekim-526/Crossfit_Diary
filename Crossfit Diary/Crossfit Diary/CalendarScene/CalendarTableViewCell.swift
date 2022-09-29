//
//  CalendarTableViewCell.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/16.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    let numberOfWODLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let wodLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    let resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    let firstLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1)
        return view
    }()
    
    let additionalTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    let secondLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1)
        return view
    }()
    
    let workoutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "CalendarTableViewCell")
        configureUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [wodLabel, firstLine, additionalTextLabel, secondLine, workoutLabel, resultLabel].forEach { self.addSubview($0) }
    }
    
    func makeConstraints() {
        let spacing = 20
        let spacingBetweenLabel = 13.5
        wodLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
        }
        resultLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.wodLabel.snp.top).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
        }
        firstLine.snp.makeConstraints { make in
            make.top.equalTo(wodLabel.snp.bottom).offset(spacingBetweenLabel / 2)
            make.height.equalTo(1.5)
            make.leading.equalTo(spacing)
            make.trailing.equalTo(-spacing)
        }
        additionalTextLabel.snp.makeConstraints { make in
            make.top.equalTo(wodLabel.snp.bottom).offset(spacingBetweenLabel)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
        }
        secondLine.snp.makeConstraints { make in
            make.top.equalTo(additionalTextLabel.snp.bottom).offset(spacingBetweenLabel / 2)
            make.height.equalTo(1.5)
            make.leading.equalTo(spacing)
            make.trailing.equalTo(-spacing)
        }
        workoutLabel.snp.makeConstraints { make in
            make.top.equalTo(additionalTextLabel.snp.bottom).offset(spacingBetweenLabel)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
