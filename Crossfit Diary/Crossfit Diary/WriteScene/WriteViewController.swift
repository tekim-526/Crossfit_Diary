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
    
    var repsList: [String] = [] {
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
    
    var task: WODRealmTable?
    
    override func loadView() {
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // writeView delegates
        writeView.barbellTextField.delegate = self
        writeView.dumbellTextField.delegate = self
        writeView.kettlebellTextField.delegate = self
        writeView.medicineBallTextField.delegate = self
        writeView.weightedVestTextField.delegate = self
        writeView.teamTextField.delegate = self
        writeView.minuteTextField.delegate = self
        
        modifyVC.delegate = self
        workoutListVC.delegate = self
        writeView.tableView.delegate = self
        writeView.tableView.dataSource = self
        writeView.tableView.register(WorkOutListTableViewCell.self, forCellReuseIdentifier: "WorkOutListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = DateFormatter().makeNavigationTitle(selectedDate: selectedDate)
        print(kindOfWOD)
        if isNew {
            makeWODString(kindOfWOD: kindOfWOD)
            tasks = wodCRUD.fetch()
            wodCRUD.addTask(task: WODRealmTable()) {
                print("error")
            }
            print(#function, writeView.teamLabel.isHidden)
        } else {
            writeView.barbellTextField.text = task?.bbWeight
            writeView.dumbellTextField.text = task?.dbWeight
            writeView.kettlebellTextField.text = task?.kbWeight
            writeView.medicineBallTextField.text = task?.mbWeight
            writeView.weightedVestTextField.text = task?.vestWeight
            writeView.teamTextField.text = task?.peopleCount
            writeView.minuteTextField.text = task?.rounds
            writeView.additionalTextView.text = task?.additionalText
            workoutList = task?.workOutArray ?? []
            repsList = task?.repsArray ?? []
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // save data to realm
        print(isNew)
        if isNew {
            if workoutList != [] || writeView.additionalTextView.text != "" {
                updateRealm(task: tasks.last!)
            } else {
                if isNew == true {
                    wodCRUD.deleteTask(task: tasks.last!) {
                        print("error")
                    }
                }
            }
        } else {
            if workoutList != [] || writeView.additionalTextView.text != "" {
                updateRealm(task: task!)
            } else {
                if isNew == true {
                    wodCRUD.deleteTask(task: task!) {
                        print("error")
                    }
                }
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
        writeView.teamTextField.text = nil
        workoutList = []
        repsList = []
    }
    
    override func setupUI() {
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        let finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonTapped))
        navigationItem.rightBarButtonItems = [finishButton, plusButton]
    }
    @objc func plusButtonTapped() {
        workoutListVC.workoutList = workoutList
        workoutListVC.repsList = repsList
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
            writeView.teamLabel.isHidden = false
            writeView.teamTextField.isHidden = false
        case "For Time":
            writeView.minuteLabel.text = " Round(s) For Time"
            writeView.minuteTextField.placeholder = "n"
            writeView.minuteLabel.isHidden = false
            writeView.minuteTextField.isHidden = false
            writeView.kindOfWODLabel.isHidden = true
            writeView.teamLabel.isHidden = false
            writeView.teamTextField.isHidden = false
        case "EMOM":
            writeView.kindOfWODLabel.text = "EMOM"
            writeView.minuteLabel.text = "minutes"
            writeView.minuteTextField.placeholder = "min"
            writeView.kindOfWODLabel.isHidden = false
            writeView.minuteTextField.isHidden = false
            writeView.minuteLabel.isHidden = false
            writeView.teamLabel.isHidden = true
            writeView.teamTextField.isHidden = true
        case "Extra":
            writeView.kindOfWODLabel.text = "Extra"
            writeView.kindOfWODLabel.isHidden = false
            writeView.minuteTextField.isHidden = true
            writeView.minuteLabel.isHidden = true
            writeView.teamLabel.isHidden = true
            writeView.teamTextField.isHidden = true
        default:
            print("default")
        }
    }
    func updateRealm(task: WODRealmTable) {
        
        wodCRUD.updateAll(task: task,
                          workOutArray: workoutList,
                          repsArray: repsList,
                          kindOfWOD: kindOfWOD,
                          bbWeight: writeView.barbellTextField.text!,
                          dbWeight: writeView.dumbellTextField.text!,
                          kbWeight: writeView.kettlebellTextField.text!,
                          mbWeight: writeView.medicineBallTextField.text!,
                          vestWeight: writeView.weightedVestTextField.text!,
                          peopleCount: writeView.teamTextField.text!,
                          rounds: writeView.minuteTextField.text!,
                          additionalText: writeView.additionalTextView.text,
                          results: "",
                          date: selectedDate ?? Date()) {
            print("error")
        }
    }

}

extension WriteViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SendWorkoutListDelegate, SendRepsDelegate {
    // 추가된 운동의 반복 횟수 배열 -> "0"으로 초기화 되어 있음
    func getWorkoutRepsList(list: [String]) {
        self.repsList = list
    }
    // 실질적인 횟수를 입력했을 때 데이터를 넣어주는 부분
    func getRepsString(reps: [String]) {
        self.repsList = reps
        
    }
    func getWorkoutList(list: [String]) {
        workoutList = list
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOutListTableViewCell", for: indexPath) as? WorkOutListTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = repsList[indexPath.row] == "0" ? workoutList[indexPath.row] : repsList[indexPath.row] + " " + workoutList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        modifyVC.indexPath = indexPath
        modifyVC.repsList = repsList
        modifyVC.modifyView.workoutLabel.text = workoutList[indexPath.row]
        present(modifyVC, animated: true)
    }
    
    // MARK: - TextField Method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if textField == writeView.teamTextField {
            if range.location >= 1 {
                return false
            }
        } else if textField == writeView.minuteTextField {
            if range.location >= 2 {
                return false
            }
        } else {
            if range.location >= 4 {
                return false
            }
        }
        if string.isEmpty || string >= "0" && string <= "9" {
            return true
        }
        return false
    }

}
