//
//  IterationOverride.swift
//  PTProject
//
//  Created by pivotal on 6/19/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct IterationOverride : Hashable {
    let number : Int
    let length : Int?
    let teamStrength : Double
    
    var hashValue: Int {
        return number.hashValue;
    }
}

func ==(lhs: IterationOverride, rhs: IterationOverride) -> Bool {
    return lhs.number == rhs.number && lhs.length == rhs.length && lhs.teamStrength == rhs.teamStrength
}
