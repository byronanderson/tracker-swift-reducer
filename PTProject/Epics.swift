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
            epics[id] = Epic(id: id, labelId: labelId, name: name, description: description)
        }
        return Epics(epics: epics)
    }
    
    static func reduce(epics: Epics, action: ProjectAction) -> Epics {
        var newEpics = epics;
        action.results.forEach { (result) in
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
                        epicDetails = ["id": result.id!, "description": ""]
                    }
                    if (result.label_id != nil) {
                        epicDetails["labelId"] = result.label_id! as Int64
                    }
                    if (result.name != nil) {
                        epicDetails["name"] = result.name! as String
                    }
                    if (result.description != nil) {
                        epicDetails["description"] = result.description! as String
                    }
                    var newMap = newEpics.epics
                    newMap[result.id!] = deserialize(dict: epicDetails)
                    newEpics = Epics(epics: newMap)
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
            "name": epic.name
        ];
    }
    
    static func deserialize(dict: NSDictionary) -> Epic {
        return Epic(
            id: dict.object(forKey: "id") as! Int64,
            labelId: dict.object(forKey: "labelId") as! Int64,
            name: dict.object(forKey: "name") as! String,
            description: dict.object(forKey: "description") as! String
        )
    }
    
    static func epicsById(epics: Epics) -> [Int64 : Epic] {
        return epics.epics;
    }
}
