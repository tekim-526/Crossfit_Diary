//
//  DateFormatter+Extension.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/14.
//

import Foundation

extension DateFormatter {
    func makeNavigationTitle(selectedDate: Date?) -> String {
        self.dateFormat = "YY.MM.dd"
        return self.string(from: selectedDate ?? Date()) + " WOD"
    }
}

