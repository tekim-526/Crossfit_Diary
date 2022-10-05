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
    
    var workout: [Workout]! = [] {
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
    
    var picker: UIPickerView!
    
    var roundCountList: [String] = []
    var repsCountList: [String] = [String]()
    
    var timeList: [[String]] = [Array(0...60).map {String(describing: $0) + "m"}, Array(0...59).map {String(describing: $0) + "s"}]
    var extraList: [String] = Array(1...350).map {String(describing: $0)}
    
    var distinguishPicker = 0 // 0: AMRAP, 1: For Time, 2: EMOM, 3: Extra
    var section = 0
    
    // 기록 값
    var firstString = ""
    var secondString = ""
    var lastString = "" {
        didSet {
            writeView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
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
        writeView.tableView.register(WriteTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: WriteTableViewHeaderView.id)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = DateFormatter().makeNavigationTitle(selectedDate: selectedDate)
        makeWODString(kindOfWOD: kindOfWOD)
        if isNew {
            workout = []
        } else {
            let itoAarr = itoaArr(bb: task?.bbWeight, db: task?.dbWeight, kb: task?.kbWeight, mb: task?.mbWeight, v: task?.vestWeight)
            
            writeView.barbellTextField.text = String(describing: itoAarr[0])
            writeView.dumbellTextField.text = String(describing: itoAarr[1])
            writeView.kettlebellTextField.text = String(describing: itoAarr[2])
            writeView.medicineBallTextField.text = String(describing: itoAarr[3])
            writeView.weightedVestTextField.text = String(describing: itoAarr[4])
            writeView.teamTextField.text = task?.peopleCount
            writeView.minuteTextField.text = task?.rounds
            writeView.additionalTextView.text = task?.additionalText
            workout = task?.workoutWithRepsArray ?? []
            lastString = task?.resultText ?? ""
        }
        makePickerArr()
        
        picker.selectRow(0, inComponent: 0, animated: true)
        if picker.numberOfComponents == 2 {
            picker.selectRow(0, inComponent: 1, animated: true)
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
            if workout != [] || !writeView.additionalTextView.text.isEmpty {
                updateRealm(task: tasks.last!)
                
            } else {
                wodCRUD.deleteTask(task: tasks.last!) {
                    showAlert(title: "WOD를 지우는 중에 오류가 발생했습니다.", message: "다시 시도해 보세요.")
                }
            }
        } else {
            if workout != [] || !writeView.additionalTextView.text.isEmpty {
                updateRealm(task: task!)
            } else {
                wodCRUD.deleteTask(task: task!) {
                    showAlert(title: "WOD를 지우는 중에 오류가 발생했습니다.", message: "다시 시도해 보세요.")
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
        writeView.additionalTextView.text = nil
        firstString = ""
        secondString = ""
        lastString = ""
    }
    
    override func setupUI() {
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        let finishButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishButtonTapped))
        navigationItem.rightBarButtonItems = [finishButton, plusButton]
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
                          kindOfWOD: kindOfWOD,
                          bbWeight: Int(writeView.barbellTextField.text!),
                          dbWeight: Int(writeView.dumbellTextField.text!),
                          kbWeight: Int(writeView.kettlebellTextField.text!),
                          mbWeight: Int(writeView.medicineBallTextField.text!),
                          vestWeight: Int(writeView.weightedVestTextField.text!),
                          peopleCount: writeView.teamTextField.text!,
                          rounds: writeView.minuteTextField.text!,
                          additionalText: writeView.additionalTextView.text,
                          resultText: lastString,
                          date: selectedDate ?? Date(),
                          workoutWithRepsArray: workout) {
            showAlert(title: "WOD 업데이트중에 오류가 발생했습니다.", message: "다시 시도해 보세요.")
        }
    }
   
    func makePickerArr() {
        var temp = 0
        for i in workout {
            if i.reps == 0 { temp += 1 }
            
            temp += i.reps
        }
        if temp == 0 { temp = 1 }
        roundCountList = Array(0...99).map { String(describing: $0) }
        repsCountList = Array(0...temp-1).map { String(describing: $0) }
    }
    
    @objc func plusButtonTapped() {
        workoutListVC.workout = workout
        present(workoutListVC, animated: true)
    }
    
    @objc func finishButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - PassingData Extension (Custom)
extension WriteViewController: SendWorkoutListDelegate, SendRepsDelegate{
    func getWorkoutRecordWorkout(list: [Workout]) {
        self.workout = list
    }
    func getRepsRecordReps(list: [Workout]) {
        self.workout = list
    }
    
}

// MARK: - PickerView Extension
extension WriteViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch kindOfWOD {
        case "AMRAP", "For Time":
            return 2
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { // 줄마다의 갯수
        
        switch kindOfWOD {
        case "AMRAP":
            if component == 0 {
                return roundCountList.count
            } else {
                return repsCountList.count
            }
        case "For Time":
            if component == 0 {
                return timeList[0].count
            } else {
                return timeList[1].count
            }
        default:
            return extraList.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { // 하나하나의 스트링 값
        switch kindOfWOD {
        case "AMRAP":
            if component == 0 {
                return "\(row)R"
            } else {
                return "\(row)Reps"
            }
        case "For Time":
            if component == 0 {
                return "\(row)분"
            } else {
                return "\(row)초"
            }
        default:
            return "\(row)Reps"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch kindOfWOD {
        case "AMRAP":
            if component == 0 {
                firstString = "\(row)R"
            } else {
                secondString = " \(row)Reps"
            }
            lastString = "\(firstString)\(secondString)"
        case "For Time":
            if component == 0 {
                firstString = "\(row)분"
            } else {
                secondString = " \(row)초"
            }
            lastString = "\(firstString)\(secondString)"
        default:
            firstString = "\(row)Reps"
            lastString = firstString
        }
        
    }
}

// MARK: - TableView Extension
extension WriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOutListTableViewCell", for: indexPath) as? WorkOutListTableViewCell else { return UITableViewCell() }
       
        if workout[indexPath.row].reps == 0 || workout[indexPath.row].reps == 1 {
            cell.titleLabel.text = workout[indexPath.row].workout
        } else {
            cell.titleLabel.text = "\(workout[indexPath.row].reps) \(workout[indexPath.row].workout)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        modifyVC.indexPath = indexPath
        modifyVC.workout = workout
        present(modifyVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: nil) { action, view, handler in
            self.workout.remove(at: indexPath.row)
            tableView.reloadData()
        }
        action.image = UIImage(systemName: "trash.fill")
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let workout = workout[sourceIndexPath.row]
        self.workout.remove(at: sourceIndexPath.row)
        self.workout.insert(workout, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let writeTableViewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: WriteTableViewHeaderView.id) as? WriteTableViewHeaderView else {
            return UIView()
        }
        writeTableViewHeaderView.pickerTextField.delegate = self
        writeTableViewHeaderView.pickerTextField.inputView = picker
        writeTableViewHeaderView.pickerTextField.placeholder = "기록"
        writeTableViewHeaderView.pickerTextField.text = lastString
        writeTableViewHeaderView.pickerTextField.backgroundColor = .white
        return writeTableViewHeaderView
    }
}

// MARK: - TableView Drag & Drop Extensions
extension WriteViewController: UITableViewDropDelegate, UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
}

// MARK: - TextField & TextView Extensions
extension WriteViewController: UITextFieldDelegate, UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty || string >= "0" && string <= "9" {
            let newLength = (textField.text?.count)! + string.count - range.length
            if textField == writeView.teamTextField {
                return !(newLength > 1)
            } else if textField == writeView.minuteTextField {
                return !(newLength > 2)
            } else {
                return !(newLength > 4)
            }
        } else { return false }
        
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.writeView.tableView.beginUpdates()
        self.writeView.tableView.reloadSections(IndexSet(0...0), with: .none)
        self.writeView.tableView.endUpdates()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        view.endEditing(true)
    }
  
}

