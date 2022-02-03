//
//  Account.swift
//  Bankey
//
//  Created by Denny on 03.02.2022.
//

import Foundation

struct Account: Codable {
    let id: String
    let type: AccountType
    let name: String
    let amount: Decimal
    let createdDateTime: Date
}
