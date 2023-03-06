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
    func goToSettingAlert() {
        let alert = UIAlertController(title: "권한 주세요", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "설정으로 가기", style: .destructive) {_ in
            let url = UIApplication.openSettingsURLString
            if let goSetting = URL(string: url) {
                UIApplication.shared.open(goSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    func makeNavigationUI(title: String ,rightBarButtonItem: UIBarButtonItem?) {
        navigationItem.title = title
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationBar.tintColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainColor
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
    }
}
