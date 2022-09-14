//
//  WriteVireController.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/09.
//

import UIKit

class WriteViewController: BaseViewController {
    let writeView = WriteView()
    var kindOfWOD: String?
    var selectedDate: Date?
    
    override func loadView() {
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeView.tableView.delegate = self
        writeView.tableView.dataSource = self
        writeView.tableView.register(WorkOutListTableViewCell.self, forCellReuseIdentifier: "WorkOutListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeWODString(kindOfWOD: kindOfWOD)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // save data to realm
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        writeView.minuteTextField.text = ""
    }
    
    override func setupUI() {
        navigationItem.title = DateFormatter().makeNavigationTitle(selectedDate: selectedDate)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
    }
    @objc func plusButtonTapped() {
        let vc = WorkOutListViewController()
        present(vc, animated: true)
    }
    
    func makeWODString(kindOfWOD: String?) {
        switch kindOfWOD {
        case "AMRAP":
            writeView.kindOfWODLabel.text = "AMRAP"
            writeView.minuteLabel.text = "minutes"
            writeView.kindOfWODLabel.isHidden = false
            writeView.minuteTextField.isHidden = false
            writeView.minuteLabel.isHidden = false
        case "For Time":
            writeView.minuteLabel.text = " Round(s) For Time"
            writeView.minuteTextField.placeholder = "n"
            writeView.minuteLabel.isHidden = false
            writeView.minuteTextField.isHidden = false
            writeView.kindOfWODLabel.isHidden = true
        case "EMOM":
            writeView.kindOfWODLabel.text = "EMOM"
            writeView.minuteLabel.text = "minutes"
            writeView.minuteTextField.placeholder = "min"
            writeView.kindOfWODLabel.isHidden = false
            writeView.minuteTextField.isHidden = false
            writeView.minuteLabel.isHidden = false
        default:
            writeView.kindOfWODLabel.text = "Practice"
            writeView.kindOfWODLabel.isHidden = false
            writeView.minuteTextField.isHidden = true
            writeView.minuteLabel.isHidden = true
        }
    }

}

extension WriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOutListTableViewCell", for: indexPath) as? WorkOutListTableViewCell else { return UITableViewCell() }
        cell.repsTextfield.isHidden = true
        
        return cell
    }
    
    
}
