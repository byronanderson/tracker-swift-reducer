//
//  Label.swift
//  PTProject
//
//  Created by pivotal on 6/15/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct Label : Hashable {
    let id : Int64
    let name : String
    
    var hashValue: Int {
        return id.hashValue ^ name.hashValue  &* 16777619;
    }
}

func ==(lhs: Label, rhs: Label) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name;
}
