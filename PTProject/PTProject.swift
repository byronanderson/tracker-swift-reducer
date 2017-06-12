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
        return project;
    }
}

func ==(lhs: PTProject, rhs: PTProject) -> Bool {
    return lhs.name == rhs.name;
}
