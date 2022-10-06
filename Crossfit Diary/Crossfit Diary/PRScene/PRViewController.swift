//
//  RMViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/10/05.
//

import UIKit
import RealmSwift

class RMViewController: BaseViewController {
    let rmView = PRView()
    let exerciseModel = ExerciseModel()
    let prRealmCRUD = PRRealmCRUD()
    var tasks: Results<PR>!
    let writePRVC = WritePRViewController()
    
    override func loadView() {
        view = rmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rmView.tableView.delegate = self
        rmView.tableView.dataSource = self
        rmView.tableView.register(RMTableViewCell.self, forCellReuseIdentifier: "PRTableViewCell")
        tasks = prRealmCRUD.fetch()
        if tasks.isEmpty {
            let flatRM = exerciseModel.rm.flatMap { $0 }
            for workout in flatRM {
                prRealmCRUD.addTask(task: PR(workout: workout, oneRM: nil, threeRM: nil, fiveRM: nil)) {
                    print("add Failed")
                }
            }
        }
    }
    override func setupUI() {
        makeNavigationUI(title: "PR", rightBarButtonItem: nil)
    }
}

extension RMViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return exerciseModel.rm.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Squats"
        case 1:
            return "Deadlifts"
        case 2:
            return "Presses"
        case 3:
            return "Cleans"
        case 4:
            return "Jerks"
        case 5:
            return "Snatches"
        case 6:
            return "Olympic Lifts"
        default:
            return "Others"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseModel.rm[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PRTableViewCell", for: indexPath) as? RMTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = exerciseModel.rm[indexPath.section][indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        writePRVC.task = tasks[indexCalculate(indexPath: indexPath)]
        navigationController?.pushViewController(writePRVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func indexCalculate(indexPath: IndexPath) -> Int {
        
        switch indexPath.section {
        case 0:
            return indexPath.row
        case 1:
            return sum(reps: 1) + indexPath.row
        case 2:
            return sum(reps: 2) + indexPath.row
        case 3:
            return sum(reps: 3) + indexPath.row
        case 4:
            return sum(reps: 4) + indexPath.row
        case 5:
            return sum(reps: 5) + indexPath.row
        case 6:
            return sum(reps: 6) + indexPath.row
        default:
            return sum(reps: 7) + indexPath.row
        }
    }
    func sum(reps: Int) -> Int{
        var row = 0
        for i in 0..<reps {
            row += exerciseModel.rm[i].count
        }
        return row
    }
}
