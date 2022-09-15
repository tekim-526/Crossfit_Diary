//
//  ModifyViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/15.
//

import UIKit

class ModifyViewController: BaseViewController {
    let modifyView = ModifyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        dismiss(animated: true) 
    }
}
