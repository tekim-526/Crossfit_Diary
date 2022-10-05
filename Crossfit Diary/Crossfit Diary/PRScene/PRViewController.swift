//
//  RMViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/10/05.
//

import UIKit

class RMViewController: BaseViewController {
    let rmView = PRView()
    let exerciseModel = ExerciseModel()
    
    override func loadView() {
        view = rmView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        rmView.tableView.delegate = self
        rmView.tableView.dataSource = self
        rmView.tableView.register(RMTableViewCell.self, forCellReuseIdentifier: "PRTableViewCell")
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
        navigationController?.pushViewController(WritePRViewController(), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
