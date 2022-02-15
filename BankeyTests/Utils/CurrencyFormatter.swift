//
//  CurrencyFormatter.swift
//  BankeyTests
//
//  Created by Denny on 02.02.2022.
//

import XCTest
import Foundation

@testable import Bankey

class CurrencyFormatterTests: XCTestCase {

    var formatter: CurrencyFormatter!

    override func setUp() {
        super.setUp()
        formatter = CurrencyFormatter()
    }

    func testBreakDollarsintoCents() throws {
        let result = formatter.breakIntoDollarsAndCents(929466.23)
        XCTAssertEqual(result.0, "929,466")
        XCTAssertEqual(result.1, "23")
    }
   // 929466 > $929,466.00
    func testDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(929466)
        XCTAssertEqual(result, "$929,466.00")
    }

    func testZeroDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(0)
        XCTAssertEqual(result, "$0.00")
    }

}
