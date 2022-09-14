//
//  WODRealmCRUD.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/14.
//

import Foundation
import RealmSwift

class WODRealmCRUD {
    let localRealm = try! Realm()
    
    func fetch() -> Results<WODRealmTable> {
        return localRealm.objects(WODRealmTable.self)
    }
    
    func addTask(task: WODRealmTable, completion: () -> Void) {
        do {
            try localRealm.write {
                localRealm.add(task)
            }
        } catch {
            completion()
        }
    }
    
    func deleteTask(task: WODRealmTable, completion: () -> Void) {
        do {
            try localRealm.write {
                localRealm.delete(task)
            }
        } catch {
            completion()
        }
    }
    
    func updateAll(task: WODRealmTable,
                   repsArray: [Int],
                   workOutArray: [String],
                   bbWeight: Int?,
                   dbWeight: Int?,
                   kbWeight: Int?,
                   mbWeight: Int?,
                   vestWeight: Int?,
                   rounds: Int?,
                   additionalText: String?,
                   results: String?,
                   completion: () -> Void) {
        do {
            try localRealm.write {
                task.repsArray = repsArray
                task.workOutArray = workOutArray
                task.bbWeight = bbWeight
                task.dbWeight = dbWeight
                task.kbWeight = kbWeight
                task.mbWeight = mbWeight
                task.vestWeight = vestWeight
                task.rounds = rounds
                task.additionalText = additionalText
                task.results = results
            }
        } catch {
            completion()
        }
    }
}
