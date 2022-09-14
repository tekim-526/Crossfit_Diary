//
//  CalendarViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/09.
//

import UIKit
import FSCalendar

class CalendarViewController: BaseViewController {
    let calendarView = CalendarView()
    let writeVC = WriteViewController()
    override func loadView() {
        view = calendarView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.tableView.delegate = self
        calendarView.calendar.delegate = self
        calendarView.calendar.dataSource = self
    }
    override func setupUI() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)
        let uiMenu = UIMenu(title: "운동종류", image: nil, identifier: nil, options: .displayInline, children: makePopUpMenu())
        rightBarButtonItem.menu = uiMenu
        
        navigationItem.title = "크로스핏 다이어리(가제)"
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    func makePopUpMenu() -> [UIAction] {
        let amrap = UIAction(title: "AMRAP", state: .off) { action in
            self.writeVC.kindOfWOD = "AMRAP"
            self.navigationController?.pushViewController(self.writeVC, animated: true)
        }
        let forTime = UIAction(title: "For Time", state: .off) { action in
            self.writeVC.kindOfWOD = "For Time"
            self.navigationController?.pushViewController(self.writeVC, animated: true)
        }
        let eMOM = UIAction(title: "EMOM", state: .off) { action in
            self.writeVC.kindOfWOD = "EMOM"
            self.navigationController?.pushViewController(self.writeVC, animated: true)
        }
        let extra = UIAction(title: "Extra", state: .off) { action in
            self.writeVC.kindOfWOD = nil
            self.navigationController?.pushViewController(self.writeVC, animated: true)
        }
        return [amrap, forTime, eMOM, extra]
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendarView.calendar.selectedDate != nil {
            writeVC.selectedDate = self.calendarView.calendar.selectedDate
        } else {
            writeVC.selectedDate = Date()
        }
    }
    
}