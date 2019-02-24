import XCTest
import RenderCloud

class CloudAPIProtocolTests: XCTestCase {
    var service: CloudAPIService!
    override func setUp() {
        super.setUp()
        service = MockCloudAPIService()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUniqueId() {
        let uniqueId = service.uniqueId()
        XCTAssert(uniqueId == "123", "Unique id not returned")
    }
    
    func testGetUniqueId() {
        let exp = expectation(description: "UniqueID generation by client")
        service.getUniqueId { (id) in
            guard let id = id else {
                return
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testSampleCloudFunction() {
        let exp = expectation(description: "UniqueID retrieved from cloud")
        service.cloudFunction(functionName: "sampleCloudFunction") { (result, error) in
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
        let exp = expectation(description: "Default method is POST")
        service.cloudFunction(functionName: "test", method: "GET", params: ["data": "123"]) { (results, error) in
            if let results = results as? [String: Any], let method = results["method"] as? String, let data = results["data"] as? String {
                if method == "GET" && data == "123" {
                    exp.fulfill()
                }
            }
        }
        wait(for: [exp], timeout: 1)
    }
}
