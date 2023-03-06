//
//  CalendarViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/09.
//

import UIKit

import FSCalendar
import FirebaseAnalytics

import RealmSwift

import RxCocoa
import RxDataSources
import RxSwift

final class CalendarViewController: BaseViewController {
    
    let calendarView = CalendarView()
    let writeVC = WriteViewController()
    let wodCRUD = WODRealmCRUD()
    var selectedDate: Date?
    let viewModel = CalendarViewModel()
    
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
        calendarView.tableView.rowHeight = UITableView.automaticDimension
        
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
        makeNavigationUI(title: "WODI", rightBarButtonItem: rightBarButtonItem)
        calendarView.calendar.calendarWeekdayView.weekdayLabels[0].textColor = .red
    }
    
    func makePopUpMenu() -> [UIAction] {
        let amrap = UIAction(title: "AMRAP", state: .off) { [unowned self] action in
            self.writeVC.kindOfWOD = "AMRAP"
            self.navigationController?.pushViewController(self.writeVC, animated: true)
        }
        let forTime = UIAction(title: "For Time", state: .off) { [unowned self] action in
            self.writeVC.kindOfWOD = "For Time"
            self.navigationController?.pushViewController(self.writeVC, animated: true)
        }
        let eMOM = UIAction(title: "EMOM", state: .off) { [unowned self] action in
            self.writeVC.kindOfWOD = "EMOM"
            self.navigationController?.pushViewController(self.writeVC, animated: true)
        }
        let extra = UIAction(title: "Extra", state: .off) { [unowned self] action in
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
//    func bindTableView() {
//        let datasource = RxTableViewSectionedReloadDataSource<SectionWodRealm> { [unowned self] dataSource, tableView, indexPath, item in
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }
//
//            let workoutString = viewModel.workoutString(task: self.tasks[indexPath.section])
//            cell.secondLine.isHidden = false
//
//            cell.wodLabel.text = viewModel.getCalendarTableViewString(task: self.tasks[indexPath.section])
//            cell.additionalTextLabel.text = self.tasks[indexPath.section].additionalText
//            cell.workoutLabel.attributedText = workoutString
//
//            cell.wodLabel.textAlignment = .center
//            cell.additionalTextLabel.textAlignment = .center
//            cell.workoutLabel.textAlignment = .center
//
//            cell.resultLabel.text = self.tasks[indexPath.section].resultText
//
//            if cell.additionalTextLabel.text == nil || cell.additionalTextLabel.text == "" {
//                cell.secondLine.isHidden = true
//            }
//            return cell
//        }
//        datasource.titleForHeaderInSection = { datasource, index in
//            return "WOD - \(index + 1)"
//        }
//        var sections: [SectionWodRealm] = []
//        var tmp = [WODRealm]()
//        for i in tasks {
//            tmp.append(WODRealm(wod: i))
//        }
//        sections.append(SectionWodRealm(items: tmp))
//        Observable.just(sections)
//            .bind(to: calendarView.tableView.rx.items(dataSource: datasource))
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as? CalendarTableViewCell else { return UITableViewCell() }
        let workoutString = viewModel.workoutString(task: tasks[indexPath.section])
        cell.secondLine.isHidden = false

        cell.wodLabel.text = viewModel.getCalendarTableViewString(task: tasks[indexPath.section])
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "WOD - \(section + 1)"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        header.textLabel?.textColor = .label
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

