//
//  WriteWorkOut.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/14.
//

import Foundation
import RealmSwift

class WODRealmTable: Object {
    @Persisted var workOut: List<String> = List<String>()
    @Persisted var reps: List<String> = List<String>()
    var workOutArray: [String] {
        get {
            return workOut.map { $0 }
        }
        set {
            workOut.removeAll()
            workOut.append(objectsIn: newValue)
        }
    }
    var repsArray: [String] {
        get {
            return reps.map { $0 }
        }
        set {
            reps.removeAll()
            reps.append(objectsIn: newValue)
        }
    }

    @Persisted var kindOfWOD: String?
    @Persisted var bbWeight: String?
    @Persisted var dbWeight: String?
    @Persisted var kbWeight: String?
    @Persisted var mbWeight: String?
    @Persisted var vestWeight: String?
    @Persisted var peopleCount: String = "1"
    @Persisted var rounds: String?
    @Persisted var additionalText: String?

    @Persisted var date: Date? = Date()

    @Persisted(primaryKey: true) var objectId : ObjectId
    
    convenience init(workOutArray: [String]?,
                     repsArray: [String]?,
                     kindOfWOD: String?,
                     bbWeight: String?,
                     dbWeight: String?,
                     kbWeight: String?,
                     mbWeight: String?,
                     vestWeight: String?,
                     peopleCount: String,
                     rounds: String?,
                     additionalText: String?,
                     date: Date?) {
        self.init()
        self.workOutArray = workOutArray ?? []
        self.repsArray = repsArray ?? []
        self.kindOfWOD = kindOfWOD
        self.bbWeight = bbWeight
        self.dbWeight = dbWeight
        self.kbWeight = kbWeight
        self.mbWeight = mbWeight
        self.vestWeight = vestWeight
        self.peopleCount = peopleCount
        self.rounds = rounds
        self.additionalText = additionalText
        self.date = date
        
    }
}
