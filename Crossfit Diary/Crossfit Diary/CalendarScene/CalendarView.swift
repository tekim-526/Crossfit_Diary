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
        calendar.appearance.headerTitleColor = .label
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 16, weight: .semibold)
        calendar.appearance.weekdayTextColor = .label
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.headerTitleAlignment = .center
        calendar.appearance.selectionColor = .mainColor
        calendar.appearance.eventDefaultColor = .brown
        calendar.appearance.eventSelectionColor = .brown
        calendar.appearance.todayColor = .lightGray
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        return calendar
    }()
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        return tableView
    }()
    let lineViewBetweenCalendarAndTableView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
   
    var calendarHeightConstraint: Constraint?
  
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        [calendar, lineViewBetweenCalendarAndTableView, tableView].forEach { self.addSubview($0) }
    }
    override func makeConstraints() {
        calendar.snp.makeConstraints { make in
            self.calendarHeightConstraint = make.height.equalTo(self.snp.height).multipliedBy(0.36).constraint
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(0)
    
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
