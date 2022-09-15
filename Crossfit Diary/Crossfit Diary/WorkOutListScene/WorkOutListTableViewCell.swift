//
//  WorkOutListTableViewCell.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/14.
//

import UIKit
import SnapKit

class WorkOutListTableViewCell: UITableViewCell {
   
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .label
        return view
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "WorkOutListTableViewCell")
        configureUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [titleLabel].forEach { self.contentView.addSubview($0) }
    }
    
    func makeConstraints() {
        let spacing = 12
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(spacing)
            make.width.equalTo(self.snp.width).multipliedBy(0.75)
            make.height.equalTo(self.snp.height).multipliedBy(0.4)
        }
//        repsTextfield.snp.makeConstraints { make in
//            make.centerY.equalTo(self.snp.centerY)
//            make.leading.equalTo(titleLabel.snp.trailing)
//            make.height.equalTo(titleLabel.snp.height)
//        }
//        repsLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(self.snp.centerY)
//            make.leading.equalTo(repsTextfield.snp.trailing).offset(4)
//            make.trailing.equalTo(-spacing)
//            make.height.equalTo(titleLabel.snp.height)
//        }
        
    }
}
