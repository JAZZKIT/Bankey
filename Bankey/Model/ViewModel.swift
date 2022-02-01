//
//  ViewModel.swift
//  Bankey
//
//  Created by Denny on 01.02.2022.
//

import Foundation

enum AccountType: String {
    case Banking
    case CreditCard
    case Investment
}

struct ViewModel {
    let accountType: AccountType
    let accountName: String
    let balance: Decimal
    
    var balanceAsAttributedString: NSAttributedString {
        return CurrencyFormatter().makeAttributedCurrency(balance)
    }
}
