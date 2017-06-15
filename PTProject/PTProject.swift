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
    let labels : Labels
    let epics : Epics
    let epicIds : EpicIds
    
    static func reduce(project: PTProject, action: ProjectAction) -> PTProject {
        return PTProject(
            metadata: ProjectMetadata.reduce(project: project.metadata, action: action),
            labels: Labels.reduce(labels: project.labels, action: action),
            epics: Epics.reduce(epics: project.epics, action: action),
            epicIds: EpicIds.reduce(epicIds: project.epicIds, action: action)
        );
    }
    
    static func fromJSON(json: NSDictionary) -> PTProject {
        return PTProject(
            metadata: ProjectMetadata.fromJSON(json: json),
            labels: Labels.fromJSON(json: json),
            epics: Epics.fromJSON(json: json),
            epicIds: EpicIds.fromJSON(json: json)
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
    
    static func labels(project: PTProject) -> Set<Label> {
        return Labels.labels(labels: project.labels);
    }
    
    static func epics(project: PTProject) -> [Epic] {
        let epicsById = Epics.epicsById(epics: project.epics)
        return EpicIds.epicIds(epicIds: project.epicIds).map({ (id) -> Epic in
            return epicsById[id]!
        })
    }
}
