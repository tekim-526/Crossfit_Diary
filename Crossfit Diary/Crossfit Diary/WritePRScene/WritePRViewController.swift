//
//  WritePRViewController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/10/05.
//

import UIKit

class WritePRViewController: BaseViewController {
    let writePRView = WritePRView()
    override func loadView() {
        view = writePRView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
