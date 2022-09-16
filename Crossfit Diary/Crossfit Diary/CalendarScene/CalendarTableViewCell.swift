//
//  CalendarTableViewCell.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/16.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16)
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
        [titleLabel].forEach { self.addSubview($0) }
    }
    
    func makeConstraints() {
        let spacing = 12
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(spacing)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-spacing)
        }

    }
}
