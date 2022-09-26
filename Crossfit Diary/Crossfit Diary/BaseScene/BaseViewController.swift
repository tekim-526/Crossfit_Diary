//
//  BaseViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/14.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        setupUI()
        makeConstraints()
    }
    func setupUI() { }
    func makeConstraints() { }
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
