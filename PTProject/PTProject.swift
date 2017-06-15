//
//  PTProject.swift
//  PTProject
//
//  Created by pivotal on 6/12/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct PTProject : Equatable {
    let name : String;
    let iterationLength : Int;
    
    static func reduce(project: PTProject, action: ProjectAction) -> PTProject {
        return action.results.reduce(project, { (project, result) in
            if (result.type == "project") {
                let details = serialize(project: project);
                if (result.name != nil) {
                    details.setValue(result.name!, forKey: "name")
                }
                if (result.iteration_length != nil) {
                    details.setValue(result.iteration_length!, forKey: "iterationLength")
                }
                return deserialize(dictionary: details);
            }
            return project;
        })
    }
    
    static func serialize(project: PTProject) -> NSMutableDictionary {
        return [
            "name": project.name,
            "iterationLength": project.iterationLength
        ];
    }
    
    static func deserialize(dictionary: NSDictionary) -> PTProject {
        return PTProject(
            name: dictionary.object(forKey: "name") as! String,
            iterationLength: dictionary.object(forKey: "iterationLength") as! Int
        )
    }
}

func ==(lhs: PTProject, rhs: PTProject) -> Bool {
    // lhs === rhs ||
    return lhs.name == rhs.name && lhs.iterationLength == rhs.iterationLength;
}
