//
//  WorkOutListView.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/13.
//

import UIKit
import SnapKit

class WorkOutListView: BaseView {
    let searchbar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupUI() {
        [searchbar, tableView].forEach{ self.addSubview($0) }
    }
    override func makeConstraints() {
        searchbar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(4)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(44)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchbar.snp.bottom).offset(4)
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
