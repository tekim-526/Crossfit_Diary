//
//  ExerciseModel.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/13.
//

import Foundation

struct ExerciseModel {
    // MARK: - Barbells
    var barbells: [String]
    var squats = ["Back Squat", "Back Pause Squat", "Box Squat", "Front Box Squat", "Front Squat", "Front Pause Squat", "High Bar Back Squat", "Low Bar Back Squat", "Overhead Squat", "Split Squat", "Zurcher Squat"]
    var cleans = ["Clean", "Clean Extension", "Clean Pull", "Hang Clean", "Hang Power Clean", "Hang Squat Clean", "Muscle Clean", "Power Clean", "Squat Clean", "Squat Pause Clean"]
    var presses = ["Bench Press", "Floor Press", "Push Press", "Seated Press", "Shoulder Press", "Shoulder To Overhead", "Snatch Grip Press", "Sots Press"]
    var jerks = ["Jerk Balance", "Jerk Dip", "Push Jerk", "Split Jerk", "Squat Jerk"]
    var snatches = ["Hang Power Snatch", "Hang Squat Snatch", "Muscle Snatch", "Power Snatch", "Snatch Balance", "Snatch Extension", "Snatch Pull", "Squat Pause Snatch", "Squat Snatch"]
    var deadlifts = ["Deadlift", "Romanian Deadlift", "Snatch Grip Deadlift", "Stiff Legged Deadlift", "Sumo Deadlift", "Sumo Deadlift High Pull"]
    var olympicLifts = ["Clean & Jerk", "Snatch"]
    var other = ["Back Rack Lunges", "Front Rack Lunges", "OverHead Lunges", "Thruster"]
    
    //var barbells = [squats, cleans, presses, jerks, snatches, deadlifts, olympicLifts, other]

    // MARK: - Gymnastics
    var gymnastics: [String]
    var bar = ["Banded Pull Ups", "Chest To Bar Pull Ups", "Muscle Ups", "Pull Ups", "Strict Banded Pull Ups", "Strict Chest To Bar Pull Ups", "Strict Muscle Ups", "Strict Pull Ups", "Toes To Bar", "Jumping Pull Ups"]
    var box = ["Box Jumps","Box Jump Overs", "Box Jump(Step Down)", "Box Step Ups", "Burpee Box Jump Overs"]
    var handstand = ["Handstand Hold", "Handstand Push Ups", "Handstand Walk", "Strict Handstand Push Ups"]
    var ring = ["Ring Muscle Ups", "Ring Dips", "Ring Rows", "Toes To Ring", "Dips"]
    var jumpRope = ["Single Unders", "Double Unders", "Triple Unders"]

    // MARK: - Endurance
    var endurance = ["Row", "Run", "Ski"]
    // MARK: - calisthenics
    var calisthenics: [String]
    var burpees = ["Burpees", "Target Burpees", "Burpee To Plates", "Burpee Over The Rower", "Bar Facing Burpee", "Bar Lateral Burpee", "Burpee Pull Ups"]
    var lunges = ["Lunges", "Walking Lunges"]
    var bodySquats = ["Air Squats", "Single Leg Squats"]
    var pushups = ["Hand Release Push Ups", "Kneeling Push Ups" ,"Push Ups", "Wave Push Ups"]

    // MARK: - KettleBell
    var kettlebells = ["Kettlebell Swings", "Russian Kettlebell Swings", "Kettlebell Clean", "Kettlebell Clean & Jerk", "Kettlebell Snatch", "Kettlebell Deadlift"]

    // MARK: - Dumbell
    var dumbells: [String]
    var dumbellSquat = ["Dumbell Goblet Squat", "Dumbell Squat", "Dumbell Front Squat"]
    var dumbellLunge = ["Dumbell Lunge", "Dumbell Overhead Lunge", "Dumbell Front Rack Lunge"]
    var dumbellClean = ["Dumbell Clean", "Dumbell Power Clean", "Dumbell Squat Clean", "Dumbell Hang Power Clean", "Dumbell Hang Squat Clean"]
    var dumbellSnatch = ["Dumbell Snatch", "Dumbell Power Snatch", "Dumbell Squat Snatch", "Dumbell Hang Power Snatch", "Dumbell Hang Squat Snatch"]
    var dumbellPress = ["Dumbell Push Press", "Dumbell Shoulder Press", "Dumbell Shoulder To Overhead", "Devil Press", "Single Arm Devil Press"]

    // MARK: - Others
    var others = ["AB Mat Sit Ups", "GHD Sit Ups", "Sit Ups", "Medicine Ball Clean", "Wall Ball Shot", "Rope Climbs, 15ft", "Rope Climbs, Lying To Standing", "Rest"]
    var allWorkOutArray: [[String]]
    init() {
        self.barbells = [squats, cleans, presses, jerks, snatches, deadlifts, olympicLifts, other].flatMap{ $0 }.sorted()
        self.dumbells = [dumbellSquat, dumbellLunge, dumbellClean, dumbellSnatch, dumbellPress].flatMap{ $0 }.sorted()
        self.gymnastics = [bar, box, handstand, ring, jumpRope].flatMap{ $0 }.sorted()
        self.calisthenics = [burpees, lunges, bodySquats, pushups].flatMap{ $0 }.sorted()
        self.allWorkOutArray = [barbells, dumbells, kettlebells, gymnastics, calisthenics, endurance, others]
    }
}
