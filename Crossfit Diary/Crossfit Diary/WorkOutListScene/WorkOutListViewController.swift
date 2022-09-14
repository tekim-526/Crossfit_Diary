//
//  WorkOutListViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/13.
//

import UIKit

class WorkOutListViewController: BaseViewController {
    let workOutListView = WorkOutListView()
    var allWorkOut = ExerciseModel().allWorkOutArray

    override func loadView() {
        view = workOutListView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        workOutListView.tableView.delegate = self
        workOutListView.tableView.dataSource = self
        workOutListView.searchbar.delegate = self
        workOutListView.tableView.register(WorkOutListTableViewCell.self, forCellReuseIdentifier: "WorkOutListTableViewCell")
        dump(allWorkOut)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        workOutListView.tableView.reloadData()
    }
}

extension WorkOutListViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return allWorkOut.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return allWorkOut[0].count
        case 1:
            return allWorkOut[1].count
        case 2:
            return allWorkOut[2].count
        case 3:
            return allWorkOut[3].count
        case 4:
            return allWorkOut[4].count
        case 5:
            return allWorkOut[5].count
        case 6:
            return allWorkOut[6].count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOutListTableViewCell", for: indexPath) as? WorkOutListTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = allWorkOut[indexPath.section][indexPath.row]
        return cell
            
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if allWorkOut[section].count != 0 {
            switch section {
            case 0:
                return "Barbell"
            case 1:
                return "Dumbell"
            case 2:
                return "KettleBell"
            case 3:
                return "Gymnastics"
            case 4:
                return "Calisthenics"
            case 5:
                return "Endurance"
            case 6:
                return "Others"
            default:
                return "header"
            }
        }
        return ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            allWorkOut = ExerciseModel().allWorkOutArray
            for i in allWorkOut.indices {
                allWorkOut[i] = allWorkOut[i].filter { $0.contains(searchText) }
            }
        } else {
            allWorkOut = ExerciseModel().allWorkOutArray
        }
        workOutListView.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.workOutListView.searchbar.endEditing(true)
    }
}
