//
//  PRRealmCRUD.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/10/06.
//

import Foundation
import RealmSwift

class PRRealmCRUD {
    let localRealm = try! Realm()
    
    func fetch() -> Results<PR> {
        print(localRealm.configuration.fileURL!)
        return localRealm.objects(PR.self)
    }
    
    func addTask(task: PR, completion: () -> Void) {
        do {
            try localRealm.write {
                
                localRealm.add(task)
            }
        } catch {
            completion()
        }
    }
    
    func updateTask(task: PR, oneRM: Double?, threeRM: Double?, fiveRM: Double?, completion: () -> Void) {
        do {
            try localRealm.write {
                task.oneRM = oneRM
                task.threeRM = threeRM
                task.fiveRM = fiveRM
            }
        } catch {
            completion()
        }
    }
}
