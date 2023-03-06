//
//  CalendarViewModel.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2023/02/14.
//

import Foundation
import UIKit

class CalendarViewModel {
    
    
    func getCalendarTableViewString(task: WODRealmTable) -> String {
        let kindOfWOD = task.kindOfWOD ?? "Extra"
        guard let rounds = task.rounds else { return "" }
        var round = rounds == "" ? "-" : rounds
        switch kindOfWOD {
        case "AMRAP":
            return "Team of \(task.peopleCount == "" ? "-" : task.peopleCount)\n\(kindOfWOD) \(round) minutes"
        case "For Time":
            if round == "-" || round == "1" {
                round = ""
            } else {
                round += " rounds "
            }
            return "Team of \(task.peopleCount == "" ? "-" : task.peopleCount)\n" + "\(round)\(kindOfWOD) Of :"
        case "EMOM":
            return "\(kindOfWOD) \(round) minutes"
        default:
            return "Extra"
        }
    }
    
    func workoutString(task: WODRealmTable) -> NSAttributedString {
        var wodStringArr: [String] = []
        for i in task.workoutWithRepsArray.indices {
            var wodString: String
            if task.workoutWithRepsArray[i].reps == 0 || task.workoutWithRepsArray[i].reps == 1 {
                wodString = task.workoutWithRepsArray[i].workout
            } else {
                wodString = "\(task.workoutWithRepsArray[i].reps) \(task.workoutWithRepsArray[i].workout)"
            }
            wodStringArr.append(wodString)
        }
        
        let attrString = NSMutableAttributedString(string: wodStringArr.reduce("") { $0 + $1 + "\n" })
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        
        return attrString
    }
}
