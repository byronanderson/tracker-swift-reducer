//
//  PTProjectTests.swift
//  PTProjectTests
//
//  Created by pivotal on 6/12/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import XCTest
@testable import PTProject

class PTProjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testProjectName() throws {
        let before = try importFixture(name: "before");
        let after = try importFixture(name: "after");
        
        let action = importCommand();
        
        XCTAssert(PTProject.reduce(project: before, action: action) == after);
    }
    
    func importFixture(name: String) throws -> PTProject {
        print(try readFile(path: "fixtures/ProjectUpdate-83179725/" + name, withExtension: "json"));
        return PTProject(name: "foobar");
    }
    
    func importCommand() -> ProjectAction {
        return ProjectAction();
    }
    
    func readFile(path: String, withExtension: String) throws -> String {
        let testBundle = Bundle(for: type(of: self))
        let url = testBundle.url(forResource: path, withExtension: withExtension)!
        let text = try String(contentsOf: url)

        return text
    }
}
