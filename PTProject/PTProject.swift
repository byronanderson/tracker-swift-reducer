//
//  PTProject.swift
//  PTProject
//
//  Created by pivotal on 6/12/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct PTProject {
    let metadata : ProjectMetadata
    
    static func reduce(project: PTProject, action: ProjectAction) -> PTProject {
        return PTProject(
            metadata: ProjectMetadata.reduce(project: project.metadata, action: action)
        );
    }
    
    static func fromJSON(json: NSDictionary) -> PTProject {
        return PTProject(
            metadata: ProjectMetadata.fromJSON(json: json)
        );
    }
    
    static func projectName(project: PTProject) -> String {
        return ProjectMetadata.projectName(project: project.metadata);
    }
    
    static func iterationLength(project: PTProject) -> Int {
        return ProjectMetadata.iterationLength(project: project.metadata);
    }
    
    static func startTime(project: PTProject) -> Int64 {
        return ProjectMetadata.startTime(project: project.metadata);
    }
    
    static func estimateBugsAndChores(project: PTProject) -> Bool {
        return ProjectMetadata.estimateBugsAndChores(project: project.metadata);
    }
    
    static func timezone(project: PTProject) -> String {
        return ProjectMetadata.timezone(project: project.metadata);
    }
    
    static func pointScale(project: PTProject) -> [Int] {
        return ProjectMetadata.pointScale(project: project.metadata);
    }
}
