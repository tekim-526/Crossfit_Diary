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
        writePRView.segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(segmented:)), for: .valueChanged)
        
    }
    
    @objc func segmentedControlValueChanged(segmented: UISegmentedControl) {
        let percentArr: [Double] = [110, 105, 95, 90, 85, 80, 75, 70, 65, 60, 55, 50]
        switch segmented.selectedSegmentIndex {
        case 0:
            changeLabelText(textField: writePRView.oneRMTextField, label: writePRView.percentLabelArray, percent: percentArr)
        case 1:
            changeLabelText(textField: writePRView.threeRMTextField, label: writePRView.percentLabelArray, percent: percentArr)
        case 2:
            changeLabelText(textField: writePRView.fiveRMTextField, label: writePRView.percentLabelArray, percent: percentArr)
        default:
            return
        }
    }
    func changeLabelText(textField: UITextField, label: [UILabel], percent: [Double]) {
        let textToDouble = Double(textField.text!)
        for i in label.indices {
            let resultString = textToDouble == nil ? "--" : "\(Int(textToDouble! * percent[i] / 100))"
            let attributedTitle =  NSMutableAttributedString(string: resultString + "\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .bold)])
            attributedTitle.append(NSAttributedString(string: "\(Int(percent[i]))" + "%", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
            
            label[i].attributedText = attributedTitle
        }
    }
    
}
