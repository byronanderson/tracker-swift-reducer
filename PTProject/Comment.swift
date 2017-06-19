//
//  Comment.swift
//  PTProject
//
//  Created by pivotal on 6/19/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct Comment : Hashable {
    let id : Int64
    let text : String
    let personId : Int64
    let fileAttachmentIds : [Int64]
    let googleAttachmentIds : [Int64]
    
    var hashValue: Int {
        return id.hashValue;
    }
}

func ==(lhs: Comment, rhs: Comment) -> Bool {
    return lhs.id == rhs.id && lhs.text == rhs.text && lhs.personId == rhs.personId && lhs.fileAttachmentIds == rhs.fileAttachmentIds && lhs.googleAttachmentIds == rhs.googleAttachmentIds;
}
