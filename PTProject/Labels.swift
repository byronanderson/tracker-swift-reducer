//
//  Labels.swift
//  PTProject
//
//  Created by pivotal on 6/15/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct Labels {
    let labels : [Int64 : Label];
    static func fromJSON(json: NSDictionary) -> Labels {
        var labels = [Int64 : Label]()
        let labelObjects = json.object(forKey: "labels") as! [NSDictionary]
        labelObjects.forEach { (dict) in
            let id = dict.object(forKey: "id") as! Int64
            let name = dict.object(forKey: "name") as! String
            labels[id] = Label(id: id, name: name)
        }
        return Labels(labels: labels)
    }
    
    static func reduce(labels: Labels, action: ProjectAction) -> Labels {
        var newLabels = labels;
        action.results.forEach { (result) in
            if (result.type == "label") {
                if (result.deleted == true) {
                    var newMap = newLabels.labels
                    newMap.removeValue(forKey: result.id!)
                    newLabels = Labels(labels: newMap)
                } else if (result.id != nil && result.name != nil) {
                    var newMap = newLabels.labels
                    newMap[result.id!] = Label(id: result.id!, name: result.name!)
                    newLabels = Labels(labels: newMap)
                }
            }
        }
        return newLabels
    }
    
    static func labels(labels: Labels) -> Set<Label> {
        return Set<Label>(labels.labels.values);
    }
}
