//
//  ProductRealmObject.swift
//  My first app
//
//  Created by ios02 on 04.03.18.
//  Copyright © 2018 ios02. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

// Product class initialization.
class Product: Object {

    @objc dynamic var name: String = ""
    @objc dynamic var weight: Double = 0
    @objc dynamic var energy: Double = 0
    @objc dynamic var protein: Double = 0
    @objc dynamic var fat: Double = 0
    @objc dynamic var carb: Double = 0

    init(name: String,
         weight: Double,
         energy: Double,
         protein: Double,
         fat: Double,
         carb: Double) {
        super.init()
        self.name = name
        self.weight = weight
        self.energy = energy
        self.protein = protein
        self.fat = fat
        self.carb = carb
        }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    required init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
}
