//
//  ModifyViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/15.
//

import UIKit

protocol SendRepsDelegate {
    func getRepsRecordReps(list: [Workout])
}

class ModifyViewController: BaseViewController {
    let modifyView = ModifyView()
    var indexPath: IndexPath!
    var delegate: SendRepsDelegate!
    
    var workout: [Workout]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modifyView.repsTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        modifyView.workoutLabel.text = workout[indexPath.row].workout
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        modifyView.repsTextField.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let repsText = Int(modifyView.repsTextField.text ?? "1")
        
        self.workout[indexPath.row] = Workout(value: ["workout" : workout[indexPath.row].workout, "reps" : repsText ?? 0])
        self.delegate.getRepsRecordReps(list: workout)
        self.modifyView.repsTextField.text = nil
    }
    override func setupUI() {
        view.addSubview(modifyView)
        modifyView.okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        
    }
    override func makeConstraints() {
        modifyView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(-72)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
            make.width.equalTo(view.snp.width).multipliedBy(0.7)
        }
    }
    @objc func okButtonTapped() {
        dismiss(animated: true)
    }
}
extension ModifyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if range.location >= 3 {
            return false
        }
        if string.isEmpty || string >= "0" && string <= "9" {
            return true
        }
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        dismiss(animated: true)
    }
}
