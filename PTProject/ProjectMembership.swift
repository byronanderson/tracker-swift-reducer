//
//  ProjectMembership.swift
//  PTProject
//
//  Created by pivotal on 6/19/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct ProjectMembership : Hashable {
    let id : Int64
    let role : String // role enum
    let personId : Int64
    let personName : String
    let personInitials : String
    let personUsername : String
    
    var hashValue: Int {
        return personId.hashValue;
    }
}

func ==(lhs: ProjectMembership, rhs: ProjectMembership) -> Bool {
    return lhs.personId == rhs.personId && lhs.role == rhs.role && lhs.id == rhs.id && lhs.personName == rhs.personName && lhs.personInitials == rhs.personInitials && lhs.personUsername == rhs.personUsername;
}
