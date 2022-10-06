//
//  UILabel+Extension.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/10/05.
//

import UIKit

extension UILabel {
    func customLabel(weightKind: String, unit: String) -> UILabel {
        let label = UILabel()
        label.text = weightKind + "\n" + "(\(unit))"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }
    func rmLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }
    func percentLabel(percent: Double, rm: Double? = nil) -> UILabel {
        let label = UILabel()
        let resultString = rm == nil ? "--" : "\(Int(rm! * percent / 100))"
        let attributedTitle =  NSMutableAttributedString(string: resultString + "\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .bold)])
        attributedTitle.append(NSAttributedString(string: "\(Int(percent))" + "%", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
        
        label.attributedText = attributedTitle
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }
}
