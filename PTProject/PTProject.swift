//
//  PTProject.swift
//  PTProject
//
//  Created by pivotal on 6/12/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

@objc class PTProject : NSObject {
    static func fromJSON(_ json : NSDictionary) -> Project {
        return Project.fromJSON(json: json)
    }
    
    static func reduce(_ project : Project, _ action : ProjectAction) -> Project {
        return Project.reduce(project:project, action:action)
    }
    
    static func projectName(project: Project) -> String {
        return ProjectMetadata.projectName(project: project.metadata)
    }
    
    static func iterationLength(project: Project) -> Int {
        return ProjectMetadata.iterationLength(project: project.metadata)
    }
    
    static func startTime(project: Project) -> Int64 {
        return ProjectMetadata.startTime(project: project.metadata)
    }
    
    static func estimateBugsAndChores(project: Project) -> Bool {
        return ProjectMetadata.estimateBugsAndChores(project: project.metadata)
    }
    
    static func timezone(project: Project) -> String {
        return ProjectMetadata.timezone(project: project.metadata)
    }
    
    static func pointScale(project: Project) -> [Int] {
        return ProjectMetadata.pointScale(project: project.metadata)
    }
    
    static func labels(project: Project) -> Set<Label> {
        return Labels.labels(labels: project.labels)
    }
    
    static func epics(project: Project) -> [Epic] {
        let epicsById = Epics.epicsById(epics: project.epics)
        return EpicIds.epicIds(epicIds: project.epicIds).map({ (id) -> Epic in
            return epicsById[id]!
        })
    }
    
    static func storiesById(project: Project) -> [Int64 : Story] {
        return Stories.storiesById(stories: project.stories)
    }
    
    static func storyIds(project: Project) -> [Int64] {
        return StoryIds.storyIds(storyIds: project.storyIds)
    }
    
    static func tasks(project: Project) -> [Int64 : Task] {
        return Tasks.tasksById(tasks: project.tasks)
    }
    
    static func comments(project: Project) -> [Int64 : Comment] {
        return Comments.commentsById(comments: project.comments)
    }
    
    static func iterationOverrides(project: Project) -> [IterationOverride] {
        return IterationOverrides.iterationOverrides(iterationOverrides: project.iterationOverrides)
    }
    
    static func fileAttachments(project: Project) -> [Int64 : FileAttachment] {
        return FileAttachments.fileAttachments(fileAttachments: project.fileAttachments)
    }
    
    static func googleAttachments(project: Project) -> [Int64 : GoogleAttachment] {
        return GoogleAttachments.googleAttachments(googleAttachments: project.googleAttachments)
    }
    
    static func activeMemberships(project: Project) -> Set<ProjectMembership> {
        return Set<ProjectMembership>(ProjectMemberships.activeMemberships(memberships: project.memberships))
    }
}

struct Project {
    let metadata : ProjectMetadata
    let labels : Labels
    let epics : Epics
    let epicIds : EpicIds
    let stories : Stories
    let storyIds : StoryIds
    let tasks : Tasks
    let comments : Comments
    let iterationOverrides : IterationOverrides
    let fileAttachments : FileAttachments
    let googleAttachments : GoogleAttachments
    let memberships : ProjectMemberships
    
    static func reduce(project: Project, action: ProjectAction) -> Project {
        return Project(
            metadata: ProjectMetadata.reduce(project: project.metadata, action: action),
            labels: Labels.reduce(labels: project.labels, action: action),
            epics: Epics.reduce(epics: project.epics, action: action),
            epicIds: EpicIds.reduce(epicIds: project.epicIds, action: action),
            stories: Stories.reduce(stories: project.stories, action: action),
            storyIds: StoryIds.reduce(storyIds: project.storyIds, action: action),
            tasks: Tasks.reduce(tasks: project.tasks, action: action),
            comments: Comments.reduce(comments: project.comments, action: action),
            iterationOverrides: IterationOverrides.reduce(iterationOverrides: project.iterationOverrides, action: action),
            fileAttachments: FileAttachments.reduce(fileAttachments: project.fileAttachments, action: action),
            googleAttachments: GoogleAttachments.reduce(googleAttachments: project.googleAttachments, action: action),
            memberships: ProjectMemberships.reduce(memberships: project.memberships, action: action)
        );
    }
    
    static func fromJSON(json: NSDictionary) -> Project {
        return Project(
            metadata: ProjectMetadata.fromJSON(json: json),
            labels: Labels.fromJSON(json: json),
            epics: Epics.fromJSON(json: json),
            epicIds: EpicIds.fromJSON(json: json),
            stories: Stories.fromJSON(json: json),
            storyIds: StoryIds.fromJSON(json: json),
            tasks: Tasks.fromJSON(json: json),
            comments: Comments.fromJSON(json: json),
            iterationOverrides: IterationOverrides.fromJSON(json: json),
            fileAttachments: FileAttachments.fromJSON(json: json),
            googleAttachments: GoogleAttachments.fromJSON(json: json),
            memberships: ProjectMemberships.fromJSON(json: json)
        );
    }
}
