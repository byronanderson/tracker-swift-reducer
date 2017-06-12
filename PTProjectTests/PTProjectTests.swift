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
        let data = try readFile(path: "fixtures/ProjectUpdate-83179725/" + name, withExtension: "json");
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
        let name = json.object(forKey: "name") as! String
        return PTProject(name: name);
    }
    
    func importCommand() -> ProjectAction {
        return ProjectAction();
    }
    
    func readFile(path: String, withExtension: String) throws -> Data {
        let testBundle = Bundle(for: type(of: self))
        let url = testBundle.url(forResource: path, withExtension: withExtension)!
        let text = try NSData(contentsOf: url) as Data

        return text
    }
}
