//
//  IterationOverrides.swift
//  PTProject
//
//  Created by pivotal on 6/19/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct IterationOverrides {
    let iterationOverrides : [IterationOverride];
    static func fromJSON(json: NSDictionary) -> IterationOverrides {
        let overrideObjects = json.object(forKey: "iteration_overrides") as! [NSDictionary]
        let iterationOverrides = overrideObjects.map({ (dict) -> IterationOverride in
            let number = dict.object(forKey: "number") as! Int
            let length = dict.object(forKey: "length") as! Int?
            let teamStrength = dict.object(forKey: "team_strength") as! Double
            return IterationOverride(number: number, length: length, teamStrength: teamStrength)
        })
        return IterationOverrides(iterationOverrides: iterationOverrides)
    }
    
    static func reduce(iterationOverrides: IterationOverrides, action: ProjectAction) -> IterationOverrides {
        var newOverrides = iterationOverrides
        
        for result in action.results {
            if result.type == "iteration" {
                let existing = findIterationWithNumber(newOverrides.iterationOverrides, result.number!);
                if (result.deleted == true) {
                    if (existing != nil) {
                        let newList = newOverrides.iterationOverrides.filter({ (override) -> Bool in
                            return override.number != existing!.number
                        })
                        newOverrides = IterationOverrides(iterationOverrides: newList)
                    }
                } else {
                    var attrs = existing == nil ? ["number": result.number!, "teamStrength": 1.0] : serialize(iterationOverride: existing!);
                    if (result.team_strength != nil) {
                        attrs["teamStrength"] = result.team_strength!
                    }
                    if result.default_length == true {
                        attrs["length"] = nil;
                    } else if (result.length != nil) {
                        attrs["length"] = result.length!;
                    }
                    var newList = newOverrides.iterationOverrides
                    let newOverride = deserialize(dict: attrs)
                    if existing != nil {
                        newList.remove(at: newList.index(of: existing!)!)
                    }
                    
                    if (newOverride.length != nil || newOverride.teamStrength != 1.0) {
                        var insertPosition = 0;
                        for override in newList {
                            if override.number < newOverride.number {
                                insertPosition += 1;
                            }
                        }
                        newList.insert(newOverride, at: insertPosition)
                    }
                    newOverrides = IterationOverrides(iterationOverrides: newList)
                }
            }
            if result.type == "project" && (result.start_time != nil || result.iteration_length != nil) { //  || result.week_start_day != nil
                newOverrides = IterationOverrides(iterationOverrides: []);
            }
        }
        return newOverrides
    }
    
    private static func serialize(iterationOverride: IterationOverride) -> NSMutableDictionary {
        return [
            "number": iterationOverride.number,
            "teamStrength": iterationOverride.teamStrength,
            "length": iterationOverride.length as Any
        ]
    }
    
    private static func deserialize(dict: NSDictionary) -> IterationOverride {
        return IterationOverride(
            number: dict.object(forKey: "number") as! Int,
            length: dict.object(forKey: "length") as! Int?,
            teamStrength: dict.object(forKey: "teamStrength") as! Double
        )
    }
    
    private static func findIterationWithNumber(_ overrides : [IterationOverride], _ number : Int) -> IterationOverride? {
        return overrides.first(where: { (override) -> Bool in
            return override.number == number
        })
    }
    
    static func iterationOverrides(iterationOverrides: IterationOverrides) -> [IterationOverride] {
        return iterationOverrides.iterationOverrides;
    }
}
