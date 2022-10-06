//
//  WritePRViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/10/05.
//

import UIKit
import Toast

class WritePRViewController: BaseViewController {
    let writePRView = WritePRView()
    var task: PR!
    let prRealmCRUD = PRRealmCRUD()
    
    let percentArr: [Double] = [110, 105, 95, 90, 85, 80, 75, 70, 65, 60, 55, 50]
    
    override func loadView() {
        view = writePRView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        writePRView.oneRMTextField.delegate = self
        writePRView.threeRMTextField.delegate = self
        writePRView.fiveRMTextField.delegate = self
        
        
        writePRView.segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(segmented:)), for: .valueChanged)
        writePRView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = task.workout
        
        writePRView.oneRMTextField.text = task.oneRM == nil ? "" : "\(Int(task.oneRM!))"
        writePRView.threeRMTextField.text = task.threeRM == nil ? "" : "\(Int(task.threeRM!))"
        writePRView.fiveRMTextField.text = task.fiveRM == nil ? "" : "\(Int(task.fiveRM!))"
        writePRView.segmentControl.selectedSegmentIndex = 0
        showLabelThroughSegmentIndex()
    }
    
    // MARK: - SegmentedControl
    @objc func segmentedControlValueChanged(segmented: UISegmentedControl) {
        switch segmented.selectedSegmentIndex {
        case 0:
            showLabelThroughSegmentIndex()
        case 1:
            showLabelThroughSegmentIndex()
        case 2:
            showLabelThroughSegmentIndex()
        default:
            return
        }
    }
    func changeLabelText(textField: UITextField?, label: [UILabel], percent: [Double]) {
        let textToDouble = Double(textField?.text! ?? "")
        for i in label.indices {
            let resultString = textToDouble == nil ? "--" : "\(Int(textToDouble! * percent[i] / 100))"
            let attributedTitle =  NSMutableAttributedString(string: resultString + "\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.mainColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .heavy)])
            attributedTitle.append(NSAttributedString(string: "\(Int(percent[i]))" + "%", attributes: [NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
            label[i].attributedText = attributedTitle
        }
    }
    // MARK: - Button
    @objc func saveButtonTapped() {
        let oneRM = Double(writePRView.oneRMTextField.text!)
        let threeRM = Double(writePRView.threeRMTextField.text!)
        let fiveRM = Double(writePRView.fiveRMTextField.text!)
        prRealmCRUD.updateTask(task: task, oneRM: oneRM, threeRM: threeRM, fiveRM: fiveRM) {
            self.view.makeToast("저장에 실패했습니다", duration: 1.0, position: .top)
            return
        }
        self.view.makeToast("저장되었습니다", duration: 1.0, position: .top)
        showLabelThroughSegmentIndex()
    }
    // MARK: - Button & Segment
    func showLabelThroughSegmentIndex() {
        var textField: UITextField!
        if writePRView.segmentControl.selectedSegmentIndex == 0 {
            textField = writePRView.oneRMTextField
        } else if writePRView.segmentControl.selectedSegmentIndex == 1 {
            textField = writePRView.threeRMTextField
        } else {
            textField = writePRView.fiveRMTextField
        }
        changeLabelText(textField: textField, label: writePRView.percentLabelArray, percent: percentArr)
    }
}
extension WritePRViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty || string >= "0" && string <= "9" {
            let newLength = (textField.text?.count)! + string.count - range.length
            return !(newLength > 4)
        } else {
            return false
        }
    }
}
