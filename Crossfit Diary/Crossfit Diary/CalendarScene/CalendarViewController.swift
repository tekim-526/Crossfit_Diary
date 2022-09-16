//
//  CalendarViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/09.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: BaseViewController {
    let calendarView = CalendarView()
    let writeVC = WriteViewController()
    let wodCRUD = WODRealmCRUD()
    var selectedDate: Date = Date()
    private var tasks: Results<WODRealmTable>! {
        didSet {
            calendarView.tableView.reloadData()
            writeVC.writeView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        view = calendarView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        calendarView.tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: "CalendarTableViewCell")
        calendarView.calendar.delegate = self
        calendarView.tableView.delegate = self
        calendarView.tableView.dataSource = self
        calendarView.calendar.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tasks = wodCRUD.fetchDate(date: calendarView.calendar.today!)
        print(#function ,tasks.count)
        
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
        writeVC.isNew = true
        return [amrap, forTime, eMOM, extra]
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = getCalendarTableViewString(task: tasks[indexPath.row], item: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "WOD"
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendarView.calendar.selectedDate != nil {
            writeVC.selectedDate = date
            self.selectedDate = date
            tasks = wodCRUD.fetchDate(date: selectedDate)
            print(date)
        } else {
            writeVC.selectedDate = Date()
        }
    }
    func getCalendarTableViewString(task: WODRealmTable, item: Int) -> String {
        let amrap = writeVC.kindOfWOD! + String(task.rounds ?? 0) + "minutes\n" +
        let forTime = "Team of " + String(task.peopleCount) + "\n" + String(task.rounds ?? 1) + "For Time"
        let emom = ""
        let extra = ""
        return amrap
    }
}
