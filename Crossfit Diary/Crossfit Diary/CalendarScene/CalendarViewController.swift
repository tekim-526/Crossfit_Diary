//
//  CalendarViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/09.
//

import UIKit
import UserNotifications

import FSCalendar
import FirebaseAnalytics
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
        
//        Analytics.logEvent("taesu", parameters: [
//          "name": "Taesu",
//          "full_text": "text as NSObject",
//        ])
//        
//        Analytics.setDefaultEventParameters([
//          "level_name": "Caverns01",
//          "level_difficulty": 4
//        ])
//        
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
        calendarView.tableView.rowHeight = UITableView.automaticDimension
        
        // notification
        let notificationCenter = UNUserNotificationCenter.current()
        requestNotificationAuth(notificationCenter: notificationCenter)
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
        
        navigationItem.title = "WODI"
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationBar.tintColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainColor
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        calendarView.calendar.calendarWeekdayView.weekdayLabels[0].textColor = .red
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



// MARK: - TableView Extensions
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }
        let workoutString = workoutString(task: tasks[indexPath.section])
        cell.secondLine.isHidden = false
        
        cell.wodLabel.text = getCalendarTableViewString(task: tasks[indexPath.section])
        cell.additionalTextLabel.text = tasks[indexPath.section].additionalText
        cell.workoutLabel.attributedText = workoutString
        
        cell.wodLabel.textAlignment = .center
        cell.additionalTextLabel.textAlignment = .center
        cell.workoutLabel.textAlignment = .center
        
        cell.resultLabel.text = tasks[indexPath.section].resultText
        
        if cell.additionalTextLabel.text == nil || cell.additionalTextLabel.text == "" {
            cell.secondLine.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: nil) { action, view, handler in
            self.wodCRUD.deleteTask(task: self.tasks[indexPath.section]) {
                self.showAlert(title: "WOD를 지우는 중에 오류가 발생했습니다.", message: "다시 시도해 보세요.")
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
        writeVC.view.endEditing(true)
        self.navigationController?.pushViewController(writeVC, animated: true)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "WOD - \(section + 1)"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        header.textLabel?.textColor = .label
    }

    // Method usage in TableView - Make Text
    func getCalendarTableViewString(task: WODRealmTable) -> String {
        let kindOfWOD = task.kindOfWOD ?? "Extra"
        guard let rounds = task.rounds else { return "" }
        var round = rounds == "" ? "-" : rounds
        switch kindOfWOD {
        case "AMRAP":
            return "Team of \(task.peopleCount == "" ? "-" : task.peopleCount)\n\(kindOfWOD) \(round) minutes"
        case "For Time":
            if round == "-" || round == "1" {
                round = ""
            } else {
                round += " rounds "
            }
            return "Team of \(task.peopleCount == "" ? "-" : task.peopleCount)\n" + "\(round)\(kindOfWOD) Of :"
        case "EMOM":
            return "\(kindOfWOD) \(round) minutes"
        default:
            return "Extra"
        }
    }
    
    func workoutString(task: WODRealmTable) -> NSAttributedString {
        var wodStringArr: [String] = []
        for i in task.workoutWithRepsArray.indices {
            var wodString: String
            if task.workoutWithRepsArray[i].reps == 0 || task.workoutWithRepsArray[i].reps == 1 {
                wodString = task.workoutWithRepsArray[i].workout
            } else {
                wodString = "\(task.workoutWithRepsArray[i].reps) \(task.workoutWithRepsArray[i].workout)"
            }
            wodStringArr.append(wodString)
        }
        
        let attrString = NSMutableAttributedString(string: wodStringArr.reduce("") { $0 + $1 + "\n" })
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        
        return attrString
    }
}



// MARK: - Calendar Extensions
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
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
            calendarView.calendarHeightConstraint?.update(inset: bounds.height / 1.21)
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
}

// MARK: - Notification Method (Push Alarm)
extension CalendarViewController {
    func requestNotificationAuth(notificationCenter: UNUserNotificationCenter) {
        let authOptions: UNAuthorizationOptions = UNAuthorizationOptions(arrayLiteral: .badge, .alert, .sound)
        notificationCenter.requestAuthorization(options: authOptions) { success, error in
            if success {
                self.sendNoti(notificationCenter: notificationCenter)
            }
        }
    }
    
    func sendNoti(notificationCenter: UNUserNotificationCenter) {
        notificationCenter.removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = "와디"
        content.subtitle = "오늘 운동하셨나요?"
        var dateComponents = DateComponents()
        dateComponents.hour = 22
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if error != nil {
                self.showAlert(title: "푸쉬 알람 등록을 실패했습니다.", message: "다시 시도해 보세요.")
            }
        }
    }
    
}
