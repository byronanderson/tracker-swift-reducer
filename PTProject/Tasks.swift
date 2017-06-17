//
//  Tasks.swift
//  PTProject
//
//  Created by pivotal on 6/16/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct Tasks {
    let tasks : [Int64 : Task];
    static func fromJSON(json: NSDictionary) -> Tasks {
        var tasks = [Int64 : Task]()
        let storyObjects = json.object(forKey: "stories") as! [NSDictionary]
        storyObjects.forEach { (dict) in
            let taskObjects = dict.object(forKey: "tasks") as! [NSDictionary]
            taskObjects.forEach({ (task) in
                let id = task.object(forKey: "id") as! Int64
                let description = task.object(forKey: "description") as! String
                let complete = task.object(forKey: "complete") as! Bool
                tasks[id] = Task(id: id, description: description, complete: complete)
            })
        }
        return Tasks(tasks: tasks)
    }
    
    static func reduce(tasks: Tasks, action: ProjectAction) -> Tasks {
        var newTasks = tasks
        for result in action.results {
            if result.type == "task" {
                if (result.deleted == true) {
                    var newList = newTasks.tasks
                    newList.removeValue(forKey: result.id!)
                    newTasks = Tasks(tasks: newList)
                } else {
                    var newList = newTasks.tasks
                    let attributes = findOrInitialize(tasks, result.id!)
                    if (result.description != nil) {
                        attributes["description"] = result.description!
                    }
                    if (result.complete != nil) {
                        attributes["complete"] = result.complete!
                    }

                    newList[result.id!] = deserialize(dict: attributes)
                    newTasks = Tasks(tasks: newList)
                }
            }
        }
        
        return newTasks
    }
    
    private static func findOrInitialize(_ tasks: Tasks, _ id : Int64) -> NSMutableDictionary {
        let existing = tasks.tasks[id]
        if (existing == nil) {
            return ["id": id]
        } else {
            return serialize(task: existing!)
        }
    }
    
    static func serialize(task: Task) -> NSMutableDictionary {
        return [
            "id": task.id,
            "description": task.description,
            "complete": task.complete
        ]
    }
    
    static func deserialize(dict: NSDictionary) -> Task {
        return Task(
            id: dict.object(forKey: "id") as! Int64,
            description: dict.object(forKey: "description") as! String,
            complete: dict.object(forKey: "complete") as! Bool
        )
    }
    
    static func tasksById(tasks: Tasks) -> [Int64 : Task] {
        return tasks.tasks;
    }
}
