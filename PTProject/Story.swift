//
//  Story.swift
//  PTProject
//
//  Created by pivotal on 6/15/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct Story : Hashable {
    let id : Int64
    let name : String
    let description : String
    let storyType : String
    let currentState : String
    let estimate : Int?
    let taskIds : [Int64]
    
    var hashValue: Int {
        return id.hashValue;
    }
}

func ==(lhs: Story, rhs: Story) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.description == rhs.description && lhs.storyType == rhs.storyType && lhs.currentState == rhs.currentState && lhs.estimate == rhs.estimate && lhs.taskIds == rhs.taskIds;
}
