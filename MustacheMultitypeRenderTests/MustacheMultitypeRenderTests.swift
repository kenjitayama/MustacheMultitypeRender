//
//  MustacheMultitypeRenderTests.swift
//  MustacheMultitypeRenderTests
//
//  Created by Kenji Tayama on 12/17/15.
//  Copyright © 2015 Kenji Tayama. All rights reserved.
//

import XCTest
@testable import MustacheMultitypeRender

class MustacheMultitypeRenderTests: XCTestCase {
    
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
            "distance": { (args: [String]) in
                return "Distance of \(args[0]) and \(args[1]) is far"
            }
        ]
        let implicitFilter = { (renderSource: String) in
            return "[\(renderSource)]"
        }
        
        
        
        var template = TemplateStringRender(
            templateString: "aaa {{apple}} {{candy}} {{distance(city1,city2)}}, {{distance(city3,city4)}} bbb",
            filters: filters,
            implicitFilter: implicitFilter)
        
        var renderResult = template.render([
            "apple": "cherry",
            "city1": "Tokyo",
            "city2": "New York"
            ])
        print(renderResult)
        
        template = TemplateStringRender(
            templateString: "🍏🍎 {{apple}} {{candy}} {{distance(city1,city2)}},🍜🍲 {{distance(city3,city4)}} 🍔bbb",
            filters: filters,
            implicitFilter: implicitFilter)
        renderResult = template.render([
            "apple": "cherry",
            "city1": "Tokyo",
            "city2": "New York"
            ])
        
        print(renderResult)
        
        XCTAssertNotNil(renderResult)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
