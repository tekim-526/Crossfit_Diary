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
        print(localRealm.configuration.fileURL)
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
                   workOutArray: [String]?,
                   repsArray: [String]?,
                   bbWeight: Int?,
                   dbWeight: Int?,
                   kbWeight: Int?,
                   mbWeight: Int?,
                   vestWeight: Int?,
                   rounds: Int?,
                   additionalText: String?,
                   results: String?,
                   date: Date?,
                   completion: () -> Void) {
        do {
            try localRealm.write {
                task.workOutArray = workOutArray ?? []
                task.repsArray = repsArray ?? []
                task.bbWeight = bbWeight
                task.dbWeight = dbWeight
                task.kbWeight = kbWeight
                task.mbWeight = mbWeight
                task.vestWeight = vestWeight
                task.rounds = rounds
                task.additionalText = additionalText
                task.results = results
                task.date = date
            }
        } catch {
            completion()
        }
    }
    func fetchDate(date: Date) -> Results<WODRealmTable> {
        return localRealm.objects(WODRealmTable.self).filter("date >= %@ AND date < %@", date, Date(timeInterval: 86400, since: date))
    }
}
