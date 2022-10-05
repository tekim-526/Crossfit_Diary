//
//  RMViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/10/05.
//

import UIKit

class RMViewController: BaseViewController {
    let rmView = RMView()
    
    
    override func loadView() {
        view = rmView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
