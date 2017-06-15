//
//  EpicIds.swift
//  PTProject
//
//  Created by pivotal on 6/15/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct EpicIds {
    let epicIds : [Int64]
    
    static func fromJSON(json: NSDictionary) -> EpicIds {
        let epics = json.object(forKey: "epics") as! [NSDictionary]
        let ids = epics.map { (epic) -> Int64 in
            return epic.object(forKey: "id") as! Int64
        }
        return EpicIds(epicIds: ids)
    }
    
    static func reduce(epicIds: EpicIds, action: ProjectAction) -> EpicIds {
        var newEpicIds = epicIds;
        action.results.forEach { (result) in
            if (result.type == "epic" && result.id != nil) {
                var newList = newEpicIds.epicIds;
                if (result.deleted == true || result.before_id != nil || result.after_id != nil) {
                    // TODO: double check this does not mutate
                    let index = newList.index(of: result.id!)
                    if (index != nil) {
                        newList.remove(at: index!)
                    }
                }
                if (result.deleted != true && !newList.contains(result.id!)) {
                    if (result.before_id != nil) {
                        let beforeIndex = newList.index(of: result.before_id!)!
                        newList.insert(result.id!, at: beforeIndex)
                    } else if (result.after_id != nil) {
                        let afterIndex = newList.index(of: result.after_id!)!
                        newList.insert(result.id!, at: afterIndex + 1)
                    } else {
                        newList.append(result.id!)
                    }
                }
                newEpicIds = EpicIds(epicIds: newList)
            }
        }
        return newEpicIds;
    }
    
    static func epicIds(epicIds: EpicIds) -> [Int64] {
        return epicIds.epicIds;
    }
}
