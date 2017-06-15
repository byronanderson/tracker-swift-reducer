//
//  PTProject.swift
//  PTProject
//
//  Created by pivotal on 6/12/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct ProjectMetadata {
    let name : String;
    let iterationLength : Int;
    let startTime : Int64;
    let estimateBugsAndChores : Bool;
    let timezone : String;
    let pointScale : [Int];
    
    static func reduce(project: ProjectMetadata, action: ProjectAction) -> ProjectMetadata {
        return action.results.reduce(project, { (project, result) in
            if (result.type == "project") {
                let details = serialize(project: project);
                if (result.name != nil) {
                    details.setValue(result.name!, forKey: "name")
                }
                if (result.iteration_length != nil) {
                    details.setValue(result.iteration_length!, forKey: "iterationLength")
                }
                if (result.start_time != nil) {
                    details.setValue(result.start_time!, forKey: "startTime")
                }
                if (result.bugs_and_chores_are_estimatable != nil) {
                    details.setValue(result.bugs_and_chores_are_estimatable!, forKey: "estimateBugsAndChores")
                }
                if (result.time_zone != nil) {
                    let timezone = result.time_zone!.object(forKey: "olson_name") as! String
                    details.setValue(timezone, forKey: "timezone")
                }
                if (result.point_scale != nil) {
                    let pointScale = result.point_scale!.components(separatedBy: ",").map { (numString) -> Int in
                        return Int(numString)!;
                    }
                    details.setValue(pointScale, forKey: "pointScale")
                }
                return deserialize(dictionary: details);
            }
            return project;
        })
    }
    
    static func fromJSON(json: NSDictionary) -> ProjectMetadata {
        let name = json.object(forKey: "name") as! String
        let iterationLength = json.object(forKey: "iteration_length") as! Int
        let startTime = json.object(forKey: "start_time") as! Int64
        let estimateBugsAndChores = json.object(forKey: "bugs_and_chores_are_estimatable") as! Bool
        let timezoneObj = json.object(forKey: "time_zone") as! NSDictionary
        let timezone = timezoneObj.object(forKey: "olson_name") as! String
        let pointScaleString = json.object(forKey: "point_scale") as! String
        let pointScale = pointScaleString.components(separatedBy: ",").map { (numString) -> Int in
            return Int(numString)!;
        }
        return ProjectMetadata(name: name, iterationLength: iterationLength, startTime: startTime, estimateBugsAndChores: estimateBugsAndChores, timezone: timezone, pointScale: pointScale);
    }
    
    static func serialize(project: ProjectMetadata) -> NSMutableDictionary {
        return [
            "name": project.name,
            "iterationLength": project.iterationLength,
            "startTime": project.startTime,
            "estimateBugsAndChores": project.estimateBugsAndChores,
            "timezone": project.timezone,
            "pointScale": project.pointScale
        ];
    }
    
    static func deserialize(dictionary: NSDictionary) -> ProjectMetadata {
        return ProjectMetadata(
            name: dictionary.object(forKey: "name") as! String,
            iterationLength: dictionary.object(forKey: "iterationLength") as! Int,
            startTime: dictionary.object(forKey: "startTime") as! Int64,
            estimateBugsAndChores: dictionary.object(forKey: "estimateBugsAndChores") as! Bool,
            timezone: dictionary.object(forKey: "timezone") as! String,
            pointScale: dictionary.object(forKey: "pointScale") as! [Int]
        )
    }
    
    static func projectName(project: ProjectMetadata) -> String {
        return project.name;
    }
    
    static func iterationLength(project: ProjectMetadata) -> Int {
        return project.iterationLength;
    }
    
    static func startTime(project: ProjectMetadata) -> Int64 {
        return project.startTime;
    }
    
    static func estimateBugsAndChores(project: ProjectMetadata) -> Bool {
        return project.estimateBugsAndChores;
    }
    
    static func timezone(project: ProjectMetadata) -> String {
        return project.timezone;
    }
    
    static func pointScale(project: ProjectMetadata) -> [Int] {
        return project.pointScale;
    }
}
