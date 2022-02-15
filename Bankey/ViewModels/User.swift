//
//  User.swift
//  Bankey
//
//  Created by Denny on 03.02.2022.
//

import Foundation

struct User {
    let welcomeMessage: String
    let name: String
    let date: Date

    var dateFormatted: String {
        return date.monthDayYearString
    }
}
