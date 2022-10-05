//
//  UITextField+Extension.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/10/05.
//

import UIKit

extension UITextField {
    func customTextField() -> UITextField {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 18, weight: .black)
        tf.textColor = .label
        tf.attributedPlaceholder = NSAttributedString(string: "--", attributes: [NSAttributedString.Key.foregroundColor : UIColor.label])
        tf.textAlignment = .center
        tf.keyboardType = .numberPad
        tf.resignFirstResponder()
        return tf
    }
}

