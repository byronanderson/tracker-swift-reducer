//
//  Epics.swift
//  PTProject
//
//  Created by pivotal on 6/15/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct Epics {
    let epics : [Int64 : Epic];
    static func fromJSON(json: NSDictionary) -> Epics {
        var epics = [Int64 : Epic]()
        let epicObjects = json.object(forKey: "epics") as! [NSDictionary]
        epicObjects.forEach { (dict) in
            let id = dict.object(forKey: "id") as! Int64
            let name = dict.object(forKey: "name") as! String
            let labelId = dict.object(forKey: "label_id") as! Int64
            let description = dict.object(forKey: "description") as! String? ?? ""
            let commentObjects = dict.object(forKey: "comments") as! [NSDictionary]
            let commentIds = commentObjects.map({ (obj) -> Int64 in
                return obj.object(forKey: "id") as! Int64
            })
            epics[id] = Epic(id: id, labelId: labelId, name: name, description: description, commentIds: commentIds)
        }
        return Epics(epics: epics)
    }
    
    static func reduce(epics: Epics, action: ProjectAction) -> Epics {
        var newEpics = epics;
        sortResults(action.results).forEach { (result) in
            if (result.type == "epic") {
                if (result.deleted == true) {
                    var newMap = newEpics.epics
                    newMap.removeValue(forKey: result.id!)
                    newEpics = Epics(epics: newMap)
                } else if (result.id != nil) {
                    let existing = newEpics.epics[result.id!]
                    var epicDetails : NSMutableDictionary;
                    if (existing != nil) {
                        epicDetails = serialize(epic: existing!)
                    } else {
                        epicDetails = ["id": result.id!, "description": "", "commentIds": []]
                    }
                    if (result.label_id != nil) {
                        epicDetails["labelId"] = result.label_id! as Int64
                    }
                    if (result.name != nil) {
                        epicDetails["name"] = result.name! as String
                    }
                    if (result.desc != nil) {
                        epicDetails["description"] = result.desc! as String
                    }
                    var newMap = newEpics.epics
                    newMap[result.id!] = deserialize(dict: epicDetails)
                    newEpics = Epics(epics: newMap)
                }
            }
            if result.type == "comment" {
                if result.deleted == true {
                    let epicWithComment = findEpicWithCommentId(newEpics.epics, result.id!)
                    if epicWithComment != nil {
                        var attrs = serialize(epic: epicWithComment!)
                        attrs["commentIds"] = epicWithComment!.commentIds.filter({ (id) -> Bool in
                            return id != result.id!
                        })
                        var newList = newEpics.epics
                        newList[epicWithComment!.id] = deserialize(dict: attrs)
                        newEpics = Epics(epics: newList)
                    }
                } else {
                    let existing = result.epic_id == nil ? findEpicWithCommentId(newEpics.epics, result.id!) : newEpics.epics[result.epic_id!]
                    if (existing != nil) {
                        let attrs = serialize(epic: existing!)
                        var commentIds = existing!.commentIds.filter({ (id) -> Bool in
                            return result.id! != id
                        })
                        commentIds.append(result.id!)
                        attrs["commentIds"] = commentIds
                        var newList = newEpics.epics
                        newList[existing!.id] = deserialize(dict: attrs)
                        newEpics = Epics(epics: newList)
                    }
                }
            }
        }
        return newEpics
    }
    
    static func serialize(epic: Epic) -> NSMutableDictionary {
        return [
            "id": epic.id,
            "labelId": epic.labelId,
            "description": epic.description,
            "name": epic.name,
            "commentIds": epic.commentIds
        ];
    }
    
    private static func findEpicWithCommentId(_ epics: [Int64 : Epic], _ commentId: Int64) -> Epic? {
        return epics.values.first(where: { (epic) -> Bool in
            return epic.commentIds.contains(commentId)
        })
    }
    
    private static func sortResults(_ results : [CommandResult]) -> [CommandResult] {
        return results.sorted(by: { (one, two) -> Bool in
            return categorize(one) - categorize(two) > 0;
        })
    }
    
    private static func categorize(_ result : CommandResult) -> Int {
        if result.type == "epic" {
            return 2
        } else if result.type == "task" {
            return 1
        } else if result.type == "comment" {
            return 1
        } else {
            return 0
        }
    }
    
    static func deserialize(dict: NSDictionary) -> Epic {
        return Epic(
            id: dict.object(forKey: "id") as! Int64,
            labelId: dict.object(forKey: "labelId") as! Int64,
            name: dict.object(forKey: "name") as! String,
            description: dict.object(forKey: "description") as! String,
            commentIds: dict.object(forKey: "commentIds") as! [Int64]
        )
    }
    
    static func epicsById(epics: Epics) -> [Int64 : Epic] {
        return epics.epics;
    }
}
