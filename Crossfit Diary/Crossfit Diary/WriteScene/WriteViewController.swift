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
        writeView.additionalTextView.delegate = self
        
        modifyVC.delegate = self
        workoutListVC.delegate = self
        writeView.tableView.delegate = self
        writeView.tableView.dataSource = self
        writeView.tableView.dragDelegate = self
        writeView.tableView.dropDelegate = self
        writeView.tableView.register(WorkOutListTableViewCell.self, forCellReuseIdentifier: "WorkOutListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = DateFormatter().makeNavigationTitle(selectedDate: selectedDate)
        
        if isNew {
            makeWODString(kindOfWOD: kindOfWOD)
        } else {
            makeWODString(kindOfWOD: kindOfWOD)
            
            let itoAarr = itoaArr(bb: task?.bbWeight, db: task?.dbWeight, kb: task?.kbWeight, mb: task?.mbWeight, v: task?.vestWeight)
            print(itoAarr)
            writeView.barbellTextField.text = String(describing: itoAarr[0])
            writeView.dumbellTextField.text = String(describing: itoAarr[1])
            writeView.kettlebellTextField.text = String(describing: itoAarr[2])
            writeView.medicineBallTextField.text = String(describing: itoAarr[3])
            writeView.weightedVestTextField.text = String(describing: itoAarr[4])
            writeView.teamTextField.text = task?.peopleCount
            writeView.minuteTextField.text = task?.rounds
            writeView.additionalTextView.text = task?.additionalText
            workoutList = task?.workOutArray ?? []
            repsList = task?.repsArray ?? []
        }
    }
    func itoaArr(bb: Int?, db: Int?, kb: Int?, mb: Int?, v: Int?) -> [String] {
        let bb = String(describing: bb ?? 0), db = String(describing: db ?? 0), kb = String(describing: kb ?? 0), mb = String(describing: mb ?? 0), v = String(describing: v ?? 0)
        var arr = [bb,db,kb,mb,v]
        for i in 0...4 {
            if arr[i] == "0" { arr[i] = "" }
        }
        return arr
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        // save data to realm
        if isNew {
            tasks = wodCRUD.fetch()
            wodCRUD.addTask(task: WODRealmTable()) {
                showAlert(title: "WOD를 추가하는 중에 오류가 발생했습니다.", message: "다시 시도해 보세요.")
            }
            if workoutList != [] || !writeView.additionalTextView.text.isEmpty {
                updateRealm(task: tasks.last!)
            } else {
                wodCRUD.deleteTask(task: tasks.last!) {
                    showAlert(title: "WOD를 지우는 중에 오류가 발생했습니다.", message: "다시 시도해 보세요.")
                }
            }
        } else {
            if workoutList != [] || !writeView.additionalTextView.text.isEmpty {
                updateRealm(task: task!)
            } else {
                wodCRUD.deleteTask(task: task!) {
                    showAlert(title: "WOD를 지우는 중에 오류가 발생했습니다.", message: "다시 시도해 보세요.")
                }
            }
        }
        print("barbel weight", Int(writeView.barbellTextField.text!), #function)
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
        writeView.additionalTextView.text = nil
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
                          bbWeight: Int(writeView.barbellTextField.text!),
                          dbWeight: Int(writeView.dumbellTextField.text!),
                          kbWeight: Int(writeView.kettlebellTextField.text!),
                          mbWeight: Int(writeView.medicineBallTextField.text!),
                          vestWeight: Int(writeView.weightedVestTextField.text!),
                          peopleCount: writeView.teamTextField.text!,
                          rounds: writeView.minuteTextField.text!,
                          additionalText: writeView.additionalTextView.text,
                          date: selectedDate ?? Date()) {
            showAlert(title: "WOD 업데이트중에 오류가 발생했습니다.", message: "다시 시도해 보세요.")
        }
    }
    
}

extension WriteViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, SendWorkoutListDelegate, SendRepsDelegate {
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
       
        if repsList[indexPath.row] == "" || repsList[indexPath.row] == "0" {
            cell.titleLabel.text = workoutList[indexPath.row]
        } else {
            cell.titleLabel.text = repsList[indexPath.row] + " " + workoutList[indexPath.row]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        modifyVC.indexPath = indexPath
        modifyVC.repsList = repsList
        modifyVC.modifyView.workoutLabel.text = workoutList[indexPath.row]
        present(modifyVC, animated: true)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: nil) { action, view, handler in
            self.repsList.remove(at: indexPath.row)
            self.workoutList.remove(at: indexPath.row)
            tableView.reloadData()
        }
        action.image = UIImage(systemName: "trash.fill")
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let reps = repsList[sourceIndexPath.row]
        let workout = workoutList[sourceIndexPath.row]
        repsList.remove(at: sourceIndexPath.row)
        workoutList.remove(at: sourceIndexPath.row)
        repsList.insert(reps, at: destinationIndexPath.row)
        workoutList.insert(workout, at: destinationIndexPath.row)
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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var cnt = 0
        for i in textView.text {
            if i == "\n" { cnt += 1 }
        }
        if cnt == 1 && text == "\n" {
            return false
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        view.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
extension WriteViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension WriteViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
}
