//
//  PRRealmTable.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/10/06.
//

import Foundation
import RealmSwift

class PR: Object {
    @Persisted (primaryKey: true) var objectID: ObjectId
    @Persisted var oneRM: Double?
    @Persisted var threeRM: Double?
    @Persisted var fiveRM: Double?
    @Persisted var workout: String
    convenience init(workout: String, oneRM: Double?, threeRM: Double?, fiveRM: Double?) {
        self.init()
        self.workout = workout
        self.oneRM = oneRM
        self.threeRM = threeRM
        self.fiveRM = fiveRM
    }
}

