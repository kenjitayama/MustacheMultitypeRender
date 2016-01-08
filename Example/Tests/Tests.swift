import UIKit
import XCTest
import MustacheMultitypeRender

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let filters: [String: TemplateStringRender.Filter] = [
            "flyingTo": { (args: [String]) in
                return "\(args[0]) 🛫🛬 \(args[1])"
            }
        ]
        let implicitFilter = { (renderSource: String) in
            return "[\(renderSource)]"
        }
        
        // start/end with non-placeholder
        // 1 valid replacemnt, 1 missing replacement
        var template = TemplateStringRender(
            templateString: "start {{apple}} {{candy}} {{flyingTo(city1,city2)}} end",
            filters: filters,
            implicitFilter: implicitFilter)
        
        var renderResult = template.render([
            "apple": "cherry",
            "city1": "Tokyo",
            "city2": "New York"
            ])
        XCTAssertEqual(renderResult, "[start ][cherry][ ][candy][ ]Tokyo 🛫🛬 New York[ end]")
        
        
        // start/end with placeholder,
        // 1 valid replacemnt, 1 missing replacement
        // 1 missing filter argument (2 needed)
        template = TemplateStringRender(
            templateString: "{{apple}} {{candy}} {{flyingTo(city1,city2)}}, {{flyingTo(city1,city3)}}",
            filters: filters,
            implicitFilter: implicitFilter)
        renderResult = template.render([
            "apple": "cherry",
            "city1": "Tokyo",
            ])
        XCTAssertEqual(renderResult, "[cherry][ ][candy][ ]Tokyo 🛫🛬 city2[, ]Tokyo 🛫🛬 city3")
        
        // start with placeholder,
        // 1 valid replacemnt, 1 missing replacement
        // 2 missing filter argument (2 needed)
        template = TemplateStringRender(
            templateString: "[start ][cherry][ ][mentos][ ][distance(city1,city2)][, ]city1 🛫🛬 city3",
            filters: filters,
            implicitFilter: implicitFilter)
        renderResult = template.render([
            "apple": "cherry",
            "candy": "mentos"
            ])
        XCTAssertEqual(renderResult, "[[start ][cherry][ ][mentos][ ][distance(city1,city2)][, ]city1 🛫🛬 city3]")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
