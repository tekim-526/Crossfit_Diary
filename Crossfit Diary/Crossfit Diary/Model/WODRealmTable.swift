//
//  WriteWorkOut.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/14.
//

import Foundation
import RealmSwift

class WODRealmTable: Object {
    @Persisted var kindOfWOD: String?
    @Persisted var bbWeight: Int?
    @Persisted var dbWeight: Int?
    @Persisted var kbWeight: Int?
    @Persisted var mbWeight: Int?
    @Persisted var vestWeight: Int?
    @Persisted var peopleCount: String = "1"
    @Persisted var rounds: String?
    @Persisted var additionalText: String?
    @Persisted var resultText: String?
    
    @Persisted var date: Date? = Date()
    
    @Persisted var workoutWithReps: List<Workout> = List<Workout>()
    
    var workoutWithRepsArray: [Workout] {
        get {
            return workoutWithReps.map { $0 }
        }
        set {
            workoutWithReps.removeAll()
            workoutWithReps.append(objectsIn: newValue)
        }
    }
    
    @Persisted(primaryKey: true) var objectId : ObjectId
    
    convenience init(kindOfWOD: String?,
                     bbWeight: Int?,
                     dbWeight: Int?,
                     kbWeight: Int?,
                     mbWeight: Int?,
                     vestWeight: Int?,
                     peopleCount: String,
                     rounds: String?,
                     additionalText: String?,
                     resultText: String?,
                     date: Date?,
                     workoutWithRepsArray: [Workout]) {
        self.init()
        self.kindOfWOD = kindOfWOD
        self.bbWeight = bbWeight
        self.dbWeight = dbWeight
        self.kbWeight = kbWeight
        self.mbWeight = mbWeight
        self.vestWeight = vestWeight
        self.peopleCount = peopleCount
        self.rounds = rounds
        self.additionalText = additionalText
        self.resultText = resultText
        self.date = date
        self.workoutWithRepsArray = workoutWithRepsArray
    }
}

class Workout: Object {
    @Persisted (primaryKey: true) var objectID: ObjectId
    @Persisted var workout: String = ""
    @Persisted var reps: Int = 0
}

