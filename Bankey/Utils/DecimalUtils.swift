//
//  DecimalUtils.swift
//  Bankey
//
//  Created by Denny on 02.02.2022.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
