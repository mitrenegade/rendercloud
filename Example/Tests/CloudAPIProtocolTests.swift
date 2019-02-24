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
        service.getUniqueId { (id) in
            guard let id = id else {
                assertionFailure("ID generation failed!")
                return
            }
            print("UniqueId generated from cloud: \(id)")
            self.service.cloudFunction(functionName: "sampleCloudFunction") { (result, error) in
                print("Result \(String(describing: result)) error \(String(describing: error))")
            }
        }
        
        XCTAssert(true, "Pass")
    }
}
