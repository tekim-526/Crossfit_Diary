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
    
    var workOutArray: [String] {
        get {
            return workOut.map{$0}
        }
        set {
            workOut.removeAll()
            workOut.append(objectsIn: newValue)
        }
    }
    
    @Persisted var bbWeight: Int?
    @Persisted var dbWeight: Int?
    @Persisted var kbWeight: Int?
    @Persisted var mbWeight: Int?
    @Persisted var vestWeight: Int?
    @Persisted var peopleCount: Int = 1
    @Persisted var rounds: Int?
    @Persisted var additionalText: String?

    @Persisted var date: Date? = Date()

    @Persisted var results: String?
    
    @Persisted(primaryKey: true) var objectId : ObjectId
    
    convenience init(workOutArray: [String]?,
                     bbWeight: Int?,
                     dbWeight: Int?,
                     kbWeight: Int?,
                     mbWeight: Int?,
                     vestWeight: Int?,
                     rounds: Int?,
                     additionalText: String?,
                     results: String?,
                     date: Date?) {
        self.init()
        self.workOutArray = workOutArray ?? []
        self.bbWeight = bbWeight
        self.dbWeight = dbWeight
        self.kbWeight = kbWeight
        self.mbWeight = mbWeight
        self.vestWeight = vestWeight
        self.rounds = rounds
        self.additionalText = additionalText
        self.results = results
        self.date = date
    }
}

