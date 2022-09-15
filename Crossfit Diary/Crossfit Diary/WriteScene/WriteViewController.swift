//
//  WriteVireController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/09.
//

import UIKit
import RealmSwift

class WriteViewController: BaseViewController {
    
   
    
    let workoutListVC = WorkOutListViewController()
    let modifyVC = ModifyViewController()
    
    let writeView = WriteView()
    
    let wodCRUD = WODRealmCRUD()
    
    var isNew: Bool = false
    var kindOfWOD: String?
    var selectedDate: Date?
    var reps: String? = "" {
        didSet {
            writeView.tableView.reloadData()
        }
    }
    
    var workoutList: [String] = [] {
        didSet {
            writeView.tableView.reloadData()
        }
    }
    
    private var tasks: Results<WODRealmTable>! {
        didSet {
            writeView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modifyVC.delegate = self
        workoutListVC.delegate = self
        writeView.tableView.delegate = self
        writeView.tableView.dataSource = self
        writeView.tableView.register(WorkOutListTableViewCell.self, forCellReuseIdentifier: "WorkOutListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = DateFormatter().makeNavigationTitle(selectedDate: selectedDate)
        makeWODString(kindOfWOD: kindOfWOD)
        tasks = wodCRUD.fetch()
        wodCRUD.addTask(task: WODRealmTable()) {
            print("error")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // save data to realm
        if workoutList != [] || writeView.additionalTextView.text != "" {
            wodCRUD.updateAll(task: tasks.last!,
                              workOutArray: workoutList,
                              bbWeight: Int(writeView.barbellTextField.text!),
                              dbWeight: Int(writeView.dumbellTextField.text!),
                              kbWeight: Int(writeView.kettlebellTextField.text!),
                              mbWeight: Int(writeView.medicineBallTextField.text!),
                              vestWeight: Int(writeView.weightedVestTextField.text!),
                              rounds: Int(writeView.minuteTextField.text!),
                              additionalText: writeView.additionalTextView.text,
                              results: "",
                              date: selectedDate ?? Date()) {
                print("error")
            }
            
        } else {
            wodCRUD.deleteTask(task: tasks.last!) {
                print("error")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        writeView.minuteTextField.text = nil
        writeView.additionalTextView.text = nil
        writeView.barbellTextField.text = nil
        writeView.dumbellTextField.text = nil
        writeView.kettlebellTextField.text = nil
        writeView.weightedVestTextField.text = nil
        writeView.medicineBallTextField.text = nil
        workoutList = []
    }
    
    override func setupUI() {
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        let finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonTapped))
        navigationItem.rightBarButtonItems = [finishButton, plusButton]
    }
    @objc func plusButtonTapped() {
        
//        vc.task = tasks[0]
        present(workoutListVC, animated: true)
    }
    @objc func finishButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func makeWODString(kindOfWOD: String?) {
        switch kindOfWOD {
        case "AMRAP":
            writeView.kindOfWODLabel.text = "AMRAP"
            writeView.minuteLabel.text = "minutes"
            writeView.kindOfWODLabel.isHidden = false
            writeView.minuteTextField.isHidden = false
            writeView.minuteLabel.isHidden = false
        case "For Time":
            writeView.minuteLabel.text = " Round(s) For Time"
            writeView.minuteTextField.placeholder = "n"
            writeView.minuteLabel.isHidden = false
            writeView.minuteTextField.isHidden = false
            writeView.kindOfWODLabel.isHidden = true
        case "EMOM":
            writeView.kindOfWODLabel.text = "EMOM"
            writeView.minuteLabel.text = "minutes"
            writeView.minuteTextField.placeholder = "min"
            writeView.kindOfWODLabel.isHidden = false
            writeView.minuteTextField.isHidden = false
            writeView.minuteLabel.isHidden = false
        default:
            writeView.kindOfWODLabel.text = "Practice"
            writeView.kindOfWODLabel.isHidden = false
            writeView.minuteTextField.isHidden = true
            writeView.minuteLabel.isHidden = true
        }
    }

}

extension WriteViewController: UITableViewDelegate, UITableViewDataSource, SendWorkoutListDelegate, SendRepsDelegate {
    func getRepsString(reps: String?) {
        self.reps = reps
    }
    
    func getWorkoutList(list: [String]) {
        workoutList = list
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOutListTableViewCell", for: indexPath) as? WorkOutListTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = reps != "" ? (reps ?? "") + " " + workoutList[indexPath.row] : workoutList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        modifyVC.modifyView.workoutLabel.text = workoutList[indexPath.row]
        present(modifyVC, animated: true)
    }
    
}
