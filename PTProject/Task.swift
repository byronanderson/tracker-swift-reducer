//
//  Task.swift
//  PTProject
//
//  Created by pivotal on 6/16/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct Task : Hashable {
    let id : Int64
    let description : String
    let complete : Bool
    
    var hashValue: Int {
        return id.hashValue;
    }
}


func ==(lhs: Task, rhs: Task) -> Bool {
    return lhs.id == rhs.id && lhs.complete == rhs.complete && lhs.description == rhs.description;
}
