//
//  Epic.swift
//  PTProject
//
//  Created by pivotal on 6/15/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct Epic : Hashable {
    let id : Int64
    let labelId : Int64
    let name : String
    let description : String
    let commentIds : [Int64]
    
    var hashValue: Int {
        return id.hashValue;
    }
}

func ==(lhs: Epic, rhs: Epic) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.labelId == rhs.labelId && lhs.description == rhs.description && lhs.commentIds == rhs.commentIds;
}
