//
//  AppConstants.swift
//  My first app
//
//  Created by ios02 on 03.03.18.
//  Copyright © 2018 ios02. All rights reserved.
//

import Foundation

struct AppConstants {

    struct UserDefaultKey {
        static let genderDefaultKey = "genderDefaultKey"
        static let weightDefaultKey = "weightDefaultKey"
        static let goalDefaultKey = "goalDefaultKey"
        static let kcalDefaultKey = "kcalDefaultKey"
        static let proteinDefaultKey = "proteinDefaultKey"
        static let fatDefaultKey = "fatDefaultKey"
        static let carbsDefaultKey = "carbsDefaultKey"
    }

    struct ScreenToShow {
        static let userSignedIn = "userSignedIn"
    }

    struct Notifications {
        static let notificationName = Notification.Name("TransportNutritionDayData")
    }

    struct LocalPushNotifications {
        static let push = "push"
    }

}
