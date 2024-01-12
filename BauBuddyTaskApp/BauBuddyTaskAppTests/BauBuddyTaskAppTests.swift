//
//  BauBuddyTaskAppTests.swift
//  BauBuddyTaskApp
//
//  Created by EZGİ KARABAY on 12.01.2024.
//

import XCTest

final class BauBuddyTaskAppTests: XCTestCase {

    var qrScanner: QRScanner!

        override func setUpWithError() throws {
            qrScanner = QRScanner()
        }

        override func tearDownWithError() throws {
            qrScanner = nil
        }

        func testSetupScanner() throws {
            
            qrScanner.setupScanner()
            XCTAssertNotNil(qrScanner.captureSession, "Capture session should not be nil")
            XCTAssertNotNil(qrScanner.previewLayer, "Preview layer should not be nil")
        }

}
