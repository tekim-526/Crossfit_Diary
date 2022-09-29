//
//  CalendarTableViewHeaderView.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/27.
//

import UIKit
import SnapKit

final class WriteTableViewHeaderView: UITableViewHeaderFooterView {
    static let id = "WriteTableViewHeaderView"
   
    
    let pickerTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "기록"
        tf.font = .systemFont(ofSize: 20)
        tf.textColor = .label
        tf.textAlignment = .center
        tf.backgroundColor = .white

        tf.layer.cornerRadius = 5
        return tf
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        self.contentView.addSubview(pickerTextField)
    }
    
    private func makeConstraints() {
        let spacing = 8
        
        pickerTextField.snp.makeConstraints { make in
            make.bottom.equalTo(-spacing)
            make.width.equalTo(self.snp.width).multipliedBy(0.35)
            make.trailing.equalTo(-spacing)
        }
    }
}
