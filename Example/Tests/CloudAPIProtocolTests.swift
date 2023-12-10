import XCTest
import RenderCloud

class CloudAPIProtocolTests: XCTestCase {
    var service: CloudAPIService!
    override func setUp() {
        super.setUp()
        service = MockCloudAPIService(uniqueId: "123", results: ["response": "abc"])
    }

    func testSampleCloudFunction() {
        let exp = expectation(description: "UniqueID retrieved from cloud")
        service.cloudFunction(functionName: "helloWorld") { (result, error) in
            print("Result \(String(describing: result)) error \(String(describing: error))")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testDefaultMethod() {
        let exp = expectation(description: "Default method is POST")
        service.cloudFunction(functionName: "test") { (results, error) in
            if let results = results as? [String: Any], let method = results["method"] as? String {
                if method == "POST" {
                    exp.fulfill()
                }
            }
        }
        wait(for: [exp], timeout: 1)
    }

    func testInputParameters() {
        let exp1 = expectation(description: "Method is get")
        let exp2 = expectation(description: "Params are processed")
        let exp3 = expectation(description: "Results are returned")
        service.cloudFunction(functionName: "test", method: "GET", params: ["data": "456"]) { (results, error) in
            guard let results = results as? [String: Any] else { return }
            guard let method = results["method"] as? String else { return }
            guard let params = results["params"] as? [String: Any] else { return }
            guard let response = results["response"] as? String else { return }
            if method == "GET" {
                exp1.fulfill()
            }
            if params["data"] as? String == "456" {
                exp2.fulfill()
            }
            if response == "abc" {
                exp3.fulfill()
            }
        }
        wait(for: [exp1, exp2, exp3], timeout: 1)
    }
}
