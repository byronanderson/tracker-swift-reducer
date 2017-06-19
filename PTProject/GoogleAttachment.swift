//
//  GoogleAttachment.swift
//  PTProject
//
//  Created by pivotal on 6/19/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct GoogleAttachment : Hashable {
    let id : Int64
    let googleId : String
    let googleKind : String
    let alternateLink : String
    let title : String
    let personId : Int64
    
    var hashValue: Int {
        return id.hashValue;
    }
}

func ==(lhs: GoogleAttachment, rhs: GoogleAttachment) -> Bool {
    return lhs.id == rhs.id && lhs.googleId == rhs.googleId && lhs.googleKind == rhs.googleKind && lhs.alternateLink == rhs.alternateLink && lhs.title == rhs.title && lhs.personId == rhs.personId;
}
