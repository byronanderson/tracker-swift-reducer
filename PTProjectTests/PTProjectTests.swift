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
    
    func testProjectName() {
        let before = importFixture(name: "before");
        let after = importFixture(name: "after");
        
        let action = importCommand();
        
        XCTAssert(PTProject.reduce(project: before, action: action) == after);
    }
    
    func importFixture(name: String) -> PTProject {
        return PTProject(name: "foobar");
    }
    
    func importCommand() -> ProjectAction {
        return ProjectAction();
    }
}
