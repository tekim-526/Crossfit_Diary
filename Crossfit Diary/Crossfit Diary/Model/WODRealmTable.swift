//
//  WriteWorkOut.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/14.
//

import Foundation
import RealmSwift

class WODRealmTable: Object {
    let workOut: List<String> = List<String>()
    let reps: List<Int> = List<Int>()
    var repsArray: [Int] {
        get {
            return reps.map{$0}
        }
        set {
            reps.removeAll()
            reps.append(objectsIn: newValue)
        }
    }
    var workOutArray: [String] {
        get {
            return workOut.map{$0}
        }
        set {
            workOut.removeAll()
            workOut.append(objectsIn: newValue)
        }
    }
    @Persisted var bbWeight: Int? = 0
    @Persisted var dbWeight: Int? = 0
    @Persisted var kbWeight: Int? = 0
    @Persisted var mbWeight: Int? = 0
    @Persisted var vestWeight: Int? = 0
    @Persisted var peopleCount: Int = 1
    @Persisted var rounds: Int? = 0
    @Persisted var additionalText: String?

    @Persisted var date: Date = Date()

    @Persisted var results: String?
    
    @Persisted(primaryKey: true) var objectId : ObjectId
    
    convenience init(repsArray: [Int],
                     workOutArray: [String],
                     bbWeight: Int?,
                     dbWeight: Int?,
                     kbWeight: Int?,
                     mbWeight: Int?,
                     vestWeight: Int?,
                     rounds: Int?,
                     additionalText: String?,
                     results: String?) {
        self.init()
        self.workOutArray = workOutArray
        self.bbWeight = bbWeight
        self.dbWeight = dbWeight
        self.kbWeight = kbWeight
        self.mbWeight = mbWeight
        self.vestWeight = vestWeight
        self.rounds = rounds
        self.additionalText = additionalText
        self.results = results
    }
}

