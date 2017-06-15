//
//  Stories.swift
//  PTProject
//
//  Created by pivotal on 6/15/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct Stories {
    let stories : [Int64 : Story];
    static func fromJSON(json: NSDictionary) -> Stories {
        var stories = [Int64 : Story]()
        let storyObjects = json.object(forKey: "stories") as! [NSDictionary]
        storyObjects.forEach { (dict) in
            let id = dict.object(forKey: "id") as! Int64
            let name = dict.object(forKey: "name") as! String
            let storyType = dict.object(forKey: "story_type") as! String
            let currentState = dict.object(forKey: "current_state") as! String
            let description = dict.object(forKey: "description") as! String? ?? ""
            let estimate = dict.object(forKey: "estimate") as! Int?
            stories[id] = Story(id: id, name: name, description: description, storyType: storyType, currentState: currentState, estimate: estimate)
        }
        return Stories(stories: stories)
    }
    
    static func reduce(stories: Stories, action: ProjectAction) -> Stories {
        var newStories = stories;
        action.results.forEach { (result) in
            if (result.type == "story") {
                var newList = newStories.stories;
                if (result.deleted == true) {
                    newList.removeValue(forKey: result.id!)
                    newStories = Stories(stories: newList)
                } else if (result.id != nil) {
                    let existing = newList[result.id!]
                    var newStory : NSMutableDictionary;
                    if (existing == nil) {
                        newStory = ["id": result.id!, "name": "", "storyType": "feature", "currentState": "unscheduled", "description": ""]
                    } else {
                        newStory = serialize(story: existing!)
                    }

                    if (result.name != nil) {
                        newStory["name"] = result.name!
                    }
                    if (result.estimate != nil) {
                        if (result.estimate == -1) {
                            newStory["estimate"] = nil
                        } else {
                            newStory["estimate"] = result.estimate!
                        }
                    }
                    if (result.description != nil) {
                        newStory["description"] = result.description!
                    }
                    if (result.story_type != nil) {
                        newStory["storyType"] = result.story_type!
                    }
                    if (result.current_state != nil) {
                        newStory["currentState"] = result.current_state!
                    }
                    newList[result.id!] = deserialize(dict: newStory)
                    newStories = Stories(stories: newList)
                }
            }
        }
        return newStories
    }
    
    static func serialize(story: Story) -> NSMutableDictionary {
        return [
            "id": story.id,
            "description": story.description,
            "name": story.name,
            "currentState": story.currentState,
            "storyType": story.storyType,
            "estimate": story.estimate
        ];
    }
    
    static func deserialize(dict: NSDictionary) -> Story {
        return Story(
            id: dict.object(forKey: "id") as! Int64,
            name: dict.object(forKey: "name") as! String,
            description: dict.object(forKey: "description") as! String,
            storyType: dict.object(forKey: "storyType") as! String,
            currentState: dict.object(forKey: "currentState") as! String,
            estimate: nullToNil(dict.object(forKey: "estimate")) as! Int?
        )
    }
    
    static func nullToNil(_ value : Any?) -> Any? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    
    static func storiesById(stories: Stories) -> [Int64 : Story] {
        return stories.stories;
    }
}
