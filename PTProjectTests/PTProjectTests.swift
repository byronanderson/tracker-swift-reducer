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
        let theFixtures = try fixtures();
        for fixture in theFixtures {
            let action = try importCommand(fixture: fixture)
            let before = try importFixture(fixture: fixture, name: "before");
            let after = try importFixture(fixture: fixture, name: "after");
            XCTAssert(PTProject.reduce(project: before, action: action) == after, fixture);
        }
    }
    
    func importFixture(fixture: String, name: String) throws -> PTProject {
        let data = try readFile(path: "fixtures/" + fixture + "/" + name, withExtension: "json");
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
        let name = json.object(forKey: "name") as! String
        return PTProject(name: name);
    }
    
    func importCommand(fixture: String) throws -> ProjectAction {
        let data = try readFile(path: "fixtures/" + fixture + "/command", withExtension: "json");
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
        let commands = json.object(forKey: "stale_commands")! as! [Any]
        let command = commands.first! as! NSDictionary
        let type = command.object(forKey: "type") as! String
        let resultObjects = command.object(forKey: "results") as! [NSDictionary]
        print("fixture: " + fixture)
        let results = resultObjects.map { (dict) -> CommandResult in
            print(dict);
            let type = dict.object(forKey: "type") as! String
            let name = dict.object(forKey: "name") as! String?
            return CommandResult(type: type, name: name)
        }
        return ProjectAction(type: type, results: results)
    }
    
    func fixtures() throws -> [String] {
        let testBundle = Bundle(for: type(of: self))
        return testBundle.paths(forResourcesOfType: nil, inDirectory: "fixtures").map { (directory) -> String in
            let parts = directory.components(separatedBy: "/")
            return parts.last!
        };
    }
    
    func readFile(path: String, withExtension: String) throws -> Data {
        let testBundle = Bundle(for: type(of: self))
        let url = testBundle.url(forResource: path, withExtension: withExtension)!
        let text = try NSData(contentsOf: url) as Data

        return text
    }
}
