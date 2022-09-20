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
    var selectedDate: Date?
    
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
        // SwipeGesture
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        // calendar
        calendarView.calendar.delegate = self
        calendarView.tableView.delegate = self
        calendarView.tableView.dataSource = self
        calendarView.calendar.dataSource = self
        calendarView.tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: "CalendarTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        calendarView.calendar.reloadData()
        tasks = wodCRUD.fetchDate(date: selectedDate ?? calendarView.calendar.today!)
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
            self.writeVC.kindOfWOD = "Extra"
            self.navigationController?.pushViewController(self.writeVC, animated: true)
        }
        writeVC.task = nil
        writeVC.isNew = true
        return [amrap, forTime, eMOM, extra]
    }
    
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .up {
            calendarView.calendar.setScope(.week, animated: true)
        }
        else if swipe.direction == .down {
            calendarView.calendar.setScope(.month, animated: true)
        }
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: - TableView Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = getCalendarTableViewString(task: tasks[indexPath.section])
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: nil) { action, view, handler in
            self.wodCRUD.deleteTask(task: self.tasks[indexPath.section]) {
                print("error")
            }
            self.calendarView.calendar.reloadData()
            tableView.reloadData()
        }
        action.image = UIImage(systemName: "trash.fill")
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        writeVC.isNew = false
        writeVC.task = tasks[indexPath.section]
        writeVC.kindOfWOD = tasks[indexPath.section].kindOfWOD
        self.navigationController?.pushViewController(writeVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "WOD - \(section + 1)"
    }
    
    // MARK: - Calendar Method
    // Calendar - Set Date
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendarView.calendar.selectedDate != nil {
            writeVC.selectedDate = date
            self.selectedDate = date
            tasks = wodCRUD.fetchDate(date: selectedDate ?? calendarView.calendar.today!)
        } else {
            writeVC.selectedDate = Date()
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        if calendarView.calendar.scope == .week {
            calendarView.calendarHeightConstraint?.update(inset: bounds.height / 1.2)
        } else if calendarView.calendar.scope == .month {
            calendarView.calendarHeightConstraint?.update(offset: 0)
        }
        UIView.animate(withDuration: 0.3) {
            self.calendarView.layoutIfNeeded()
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if wodCRUD.fetchDate(date: date).isEmpty {
            return 0
        }
        return 1
    }
    
    // CalendarTableView List - Make Text
    func getCalendarTableViewString(task: WODRealmTable) -> String {
        let kindOfWOD = task.kindOfWOD ?? "Extra"
        let workoutString = workoutString(task: task)
        switch kindOfWOD {
        case "AMRAP":
            return "Team of \(task.peopleCount)\n\(kindOfWOD) \(task.rounds ?? "0")minutes\n\(task.additionalText ?? "")\n\(workoutString)"
        case "For Time":
            return "Team of \(task.peopleCount)\n\(task.rounds ?? "1")rounds \(kindOfWOD)\n\(task.additionalText ?? "")\n\(workoutString)"
        case "EMOM":
            return "\(kindOfWOD) \(task.rounds ?? "1")minutes\n\(task.additionalText ?? "")\n\(workoutString)"
        default:
            return "Extra\n\(task.additionalText ?? "")\n\(workoutString)"
        }
    }
    
    func workoutString(task: WODRealmTable) -> String {
        var wodStringArr: [String] = []
        for i in task.workOut.indices {
            let wodString = task.reps[i] == "0" ? task.workOut[i] : task.reps[i] + " " + task.workOut[i]
            wodStringArr.append(wodString)
        }
        return wodStringArr.reduce("") { $0 + $1 + "\n" }
    }
    
}
