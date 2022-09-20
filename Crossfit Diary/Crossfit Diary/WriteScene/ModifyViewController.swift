//
//  ModifyViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/15.
//

import UIKit

protocol SendRepsDelegate {
    func getRepsString(reps: [String])
}

class ModifyViewController: BaseViewController {
    let modifyView = ModifyView()
    var repsList: [String]!
    var indexPath: IndexPath!
    var delegate: SendRepsDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        modifyView.repsTextField.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        modifyView.repsTextField.becomeFirstResponder()
    }
    override func setupUI() {
        view.addSubview(modifyView)
        modifyView.okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        
    }
    override func makeConstraints() {
        modifyView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
            make.width.equalTo(view.snp.width).multipliedBy(0.7)
        }
    }
    @objc func okButtonTapped() {
        dismiss(animated: true) {
            self.repsList[self.indexPath.row] = self.modifyView.repsTextField.text ?? "0"
            self.delegate.getRepsString(reps: self.repsList)
            self.modifyView.repsTextField.text = nil
        }
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
}
