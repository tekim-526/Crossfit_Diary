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
}
