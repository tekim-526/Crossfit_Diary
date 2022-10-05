//
//  RMView.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/10/05.
//

import UIKit
import SnapKit

class PRView: BaseView {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupUI() {
        [tableView].forEach { self.addSubview($0) }
    }
    override func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
