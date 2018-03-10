//
//  Person.swift
//  My first app
//
//  Created by ios02 on 08.02.18.
//  Copyright © 2018 ios02. All rights reserved.
//

import Foundation

class Person {

    var weight: Int
    var gender: GenderType
    var goal: GoalType
    var kcal: Int
    var protein: Double
    var fat: Double
    var carbs: Double

    init(weight: Int = UserDefaults.standard.integer(forKey: AppConstants.UserDefaultKey.weightDefaultKey),
         gender: GenderType.RawValue = UserDefaults.standard.string(forKey: AppConstants.UserDefaultKey.genderDefaultKey)!,
         goal: GoalType.RawValue = UserDefaults.standard.string(forKey: AppConstants.UserDefaultKey.goalDefaultKey)!,
         kcal: Int = 0,
         protein: Double = 0,
         fat: Double = 0,
         carbs: Double = 0) {

        self.weight = weight
        self.gender = Person.GenderType(rawValue: gender)!
        self.goal = Person.GoalType(rawValue: goal)!
        self.kcal = kcal
        self.protein = protein
        self.fat = fat
        self.carbs = carbs
    }

    enum GenderType: String {
        case man = "Man"
        case woman = "Woman"

    }
    enum GoalType: String {
        case lose = "Lose"
        case maintain = "Maintain"
        case gain = "Gain"
    }

 /// Calculate KPFC according to weight, gender and goal.
    func calculateKPFC() {

        if gender.rawValue == GenderType.woman.rawValue {
            if goal.rawValue == GoalType.lose.rawValue {
                protein = 2.2 * Double(weight)
                fat = 0.8 * Double(weight)
                carbs = 1.2 * Double(weight)
            } else if goal.rawValue == GoalType.maintain.rawValue {
                protein = 1.5 * Double(weight)
                fat = 1 * Double(weight)
                carbs = 2.2 * Double(weight)
            } else if goal.rawValue == GoalType.gain.rawValue {
                protein = 1.8 * Double(weight)
                fat = 1 * Double(weight)
                carbs = 3 * Double(weight)
            }
        } else if gender.rawValue == GenderType.man.rawValue {
            if goal.rawValue == GoalType.lose.rawValue {
                protein = 2.2 * Double(weight)
                fat = 0.5 * Double(weight)
                carbs = 2.2 * Double(weight)
            } else if goal.rawValue == GoalType.maintain.rawValue {
                protein = 1.8 * Double(weight)
                fat = 0.8 * Double(weight)
                carbs = 3 * Double(weight)
            } else if goal.rawValue == GoalType.gain.rawValue {
                protein = 2 * Double(weight)
                fat = 1 * Double(weight)
                carbs = 4 * Double(weight)
            }
        }
        kcal = Int(protein * 4 + fat * 9 + carbs * 4)

        let defaults = UserDefaults.standard
        defaults.set(kcal, forKey: AppConstants.UserDefaultKey.kcalDefaultKey)
        defaults.set(protein, forKey: AppConstants.UserDefaultKey.proteinDefaultKey)
        defaults.set(fat, forKey: AppConstants.UserDefaultKey.fatDefaultKey)
        defaults.set(carbs, forKey: AppConstants.UserDefaultKey.carbsDefaultKey)
    }
}
