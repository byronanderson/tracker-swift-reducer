//
//  Comments.swift
//  PTProject
//
//  Created by pivotal on 6/19/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct Comments {
    let comments : [Int64 : Comment]
    
    static func fromJSON(json: NSDictionary) -> Comments {
        let stories = json.object(forKey: "stories") as! [NSDictionary]
        var map1 = extractComments(stories)
        let epics = json.object(forKey: "epics") as! [NSDictionary]
        let map2 = extractComments(epics)
        
        map2.forEach { (k,v) in map1[k] = v }
        return Comments(comments: map1)
    }
    
    static func reduce(comments: Comments, action: ProjectAction) -> Comments {
        var newComments = comments
        for result in action.results {
            if result.type == "comment" {
                if (result.deleted == true) {
                    var newList = newComments.comments
                    newList.removeValue(forKey: result.id!)
                    newComments = Comments(comments: newList)
                } else {
                    let existing = newComments.comments[result.id!];
                    var attrs = existing == nil ? ["id": result.id!, "text": ""] : serialize(comment: existing!);
                    if (result.text != nil) {
                        attrs["text"] = result.text!
                    }
                    if result.person_id != nil {
                        attrs["personId"] = result.person_id!
                    }
                    if result.file_attachment_ids != nil {
                        attrs["fileAttachmentIds"] = result.file_attachment_ids
                    }
                    if result.google_attachment_ids != nil {
                        attrs["googleAttachmentIds"] = result.google_attachment_ids
                    }
                    var newList = newComments.comments
                    newList[result.id!] = deserialize(dict: attrs)
                    newComments = Comments(comments: newList)
                }
            }
        }
        return newComments
    }
    
    private static func extractComments(_ things : [NSDictionary]) -> [Int64 : Comment] {
        var retVal = [Int64 : Comment]()
        for thing in things {
            let comments = thing.object(forKey: "comments") as! [NSDictionary]
            for comment in comments {
                let id = comment.object(forKey: "id") as! Int64
                let text = comment.object(forKey: "text") as! String?
                let personId = comment.object(forKey: "person_id") as! Int64
                let fileAttachments = comment.object(forKey: "file_attachments") as! [NSDictionary]
                let googleAttachments = comment.object(forKey: "google_attachments") as! [NSDictionary]
                let fileAttachmentIds = fileAttachments.map({ (dict) -> Int64 in
                    return dict.object(forKey: "id") as! Int64
                })
                let googleAttachmentIds = googleAttachments.map({ (dict) -> Int64 in
                    return dict.object(forKey: "id") as! Int64
                })
                retVal[id] = Comment(id: id, text: text ?? "", personId: personId, fileAttachmentIds: fileAttachmentIds, googleAttachmentIds: googleAttachmentIds)
            }
        }
        return retVal
    }
    
    private static func serialize(comment: Comment) -> NSMutableDictionary {
        return [
            "id": comment.id,
            "text": comment.text as Any,
            "personId": comment.personId,
            "fileAttachmentIds": comment.fileAttachmentIds,
            "googleAttachmentIds": comment.googleAttachmentIds
        ]
    }
    
    private static func deserialize(dict: NSDictionary) -> Comment {
        return Comment(
            id: dict.object(forKey: "id") as! Int64,
            text: dict.object(forKey: "text") as! String,
            personId: dict.object(forKey: "personId") as! Int64,
            fileAttachmentIds: dict.object(forKey: "fileAttachmentIds") as! [Int64],
            googleAttachmentIds:  dict.object(forKey: "googleAttachmentIds") as! [Int64]
        )
    }
    
    static func commentsById(comments: Comments) -> [Int64 : Comment] {
        return comments.comments
    }
}
