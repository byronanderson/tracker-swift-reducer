//
//  PTProject.swift
//  PTProject
//
//  Created by pivotal on 6/12/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

struct PTProject : Equatable {
    let name : String;
    let iterationLength : Int;
    
    static func reduce(project: PTProject, action: ProjectAction) -> PTProject {
        return action.results.reduce(project, { (project, result) in
            var newProject = project;
            if (result.type == "project") {
                if (result.name != nil) {
                    newProject = PTProject(name: result.name!, iterationLength: newProject.iterationLength);
                }
                if (result.iteration_length != nil) {
                    newProject = PTProject(name: newProject.name, iterationLength: result.iteration_length!);
                }
            }
            return newProject;
        })
    }
}

func ==(lhs: PTProject, rhs: PTProject) -> Bool {
    // lhs === rhs ||
    return lhs.name == rhs.name && lhs.iterationLength == rhs.iterationLength;
}
