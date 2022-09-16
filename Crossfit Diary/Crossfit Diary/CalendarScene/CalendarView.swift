//
//  CalendarView.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/09.
//

import UIKit
import SnapKit
import FSCalendar

class CalendarView: BaseView {
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.headerTitleAlignment = .center
        return calendar
    }()
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemMint
        return tableView
    }()
    let lineViewBetweenBarAndCalendar: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    let lineViewBetweenCalendarAndTableView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        [lineViewBetweenBarAndCalendar, calendar, lineViewBetweenCalendarAndTableView, tableView].forEach { self.addSubview($0) }
    }
    override func makeConstraints() {
        lineViewBetweenBarAndCalendar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(0.5)
        }
        calendar.snp.makeConstraints { make in
            make.top.equalTo(lineViewBetweenBarAndCalendar.snp.bottom)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(self.snp.height).multipliedBy(0.36)
        }
        lineViewBetweenCalendarAndTableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(0.5)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(1)
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
