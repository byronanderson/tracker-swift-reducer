//
//  PTProject.swift
//  PTProject
//
//  Created by pivotal on 6/12/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

struct PTProject : Equatable {
    let name: String;
    
    static func reduce(project: PTProject, action: ProjectAction) -> PTProject {
        return action.results.reduce(project, { (project, result) in
            if (result.type == "project" && result.name != nil) {
                return PTProject(name: result.name!);
            }
            return project;
        })
    }
}

func ==(lhs: PTProject, rhs: PTProject) -> Bool {
    return lhs.name == rhs.name;
}
