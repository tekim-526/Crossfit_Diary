//
//  WorkOutList.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/15.
//

import Foundation

class WorkOutList<T> {
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    init(_ value: T) {
        self.value = value
    }
    func bind(completionHandler: @escaping (T) -> Void) {
        completionHandler(value)
        listener = completionHandler
    }
}

class WorkoutList {
    var list: [String] = []
}
