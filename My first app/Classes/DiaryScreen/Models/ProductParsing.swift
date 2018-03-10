//
//  ProductParsing.swift
//  My first app
//
//  Created by ios02 on 22.02.18.
//  Copyright © 2018 ios02. All rights reserved.
//

import Foundation

// Struct for parsing product's ID.
struct ProductID {

    let name: String
    let ID: String

    struct Keys {
        static let name = "name"
        static let ndbno = "ndbno"
    }

   init?(json: [String: Any]) {
        guard let name = json[Keys.name] as? String,
        let ID = json[Keys.ndbno] as? String
        else { return nil }

        self.name = name
        self.ID = ID
    }
}

// Struct for parsing product's nutrient array.
struct ProductNutrients {

    let name: String
    let value: String

    struct Keys {
        static let name = "name"
        static let value = "value"
    }

    init?(json: [String: Any]) {
        guard let name = json[Keys.name] as? String,
        let value = json[Keys.value] as? String
        else { return nil }

        self.name = name
        self.value = value
    }
}
