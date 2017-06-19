//
//  FileAttachment.swift
//  PTProject
//
//  Created by pivotal on 6/19/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct FileAttachment : Hashable {
    let id : Int64
    let filename : String
    let uploaderId : Int64
    let downloadUrl : String?
    let thumbnailUrl : String?
    let bigUrl : String?
    
    var hashValue: Int {
        return id.hashValue;
    }
}

func ==(lhs: FileAttachment, rhs: FileAttachment) -> Bool {
    return lhs.id == rhs.id && lhs.filename == rhs.filename && lhs.uploaderId == rhs.uploaderId && lhs.downloadUrl == rhs.downloadUrl && lhs.thumbnailUrl == rhs.thumbnailUrl && lhs.bigUrl == rhs.bigUrl;
}
