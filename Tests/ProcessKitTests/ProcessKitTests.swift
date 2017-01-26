import Foundation
@testable import ProcessKit
import XCTest

class ProcessKitTests: XCTestCase {
    var process: Process!

    override func setUp() {
        super.setUp()
        process = Process()
        process.standardError = nil
    }

    func testSimpleOutput() {
        let output = try! process.exec(["echo", "Hello World!"])
        XCTAssertEqual(output, "Hello World!\n")
    }

    func testNonZeroReturn() {
        var returnCode: Int32?
        do {
            let _ = try process.exec(["cat", "/path/to/nonexistant/file"])
        } catch {
            if let processError = error as? ProcessError {
                switch processError {
                case .nonZeroReturn(let code):
                    returnCode = code
                default:
                    break
                }
            }
        }
        XCTAssertNotNil(returnCode)
    }

    static var allTests : [(String, (ProcessKitTests) -> () throws -> Void)] {
        return [
            ("testSimpleOutput", testSimpleOutput),
            ("testNonZeroReturn", testNonZeroReturn),
        ]
    }
}
