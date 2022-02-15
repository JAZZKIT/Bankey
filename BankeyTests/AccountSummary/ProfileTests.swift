//
//  ProfileTests.swift
//  BankeyTests
//
//  Created by Denny on 03.02.2022.
//

import Foundation
import XCTest

@testable import Bankey

class ProfileTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func testCanParse() throws {
        let json = """
        {
        "id": "1",
        "first_name": "Kevin",
        "last_name": "Flynn",
        }
        """

        let data = json.data(using: .utf8)!
        let result = try! JSONDecoder().decode(Profile.self, from: data) // swiftlint:disable:this force_try

        XCTAssertEqual(result.id, "1")
        XCTAssertEqual(result.firstName, "Kevin")
        XCTAssertEqual(result.lastName, "Flynn")
    }
}
