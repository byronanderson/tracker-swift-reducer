//
//  GoogleAttachments.swift
//  PTProject
//
//  Created by pivotal on 6/19/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct GoogleAttachments {
    let googleAttachments : [Int64 : GoogleAttachment];
    static func fromJSON(json: NSDictionary) -> GoogleAttachments {
        var googleAttachments = [Int64 : GoogleAttachment]()
        let stories = json.object(forKey: "stories") as! [NSDictionary]
        let epics = json.object(forKey: "epics") as! [NSDictionary]
        let list = extractAttachments(stories) + extractAttachments(epics)
        
        list.forEach { (attachment) in
            googleAttachments[attachment.id] = attachment
        }
        
        return GoogleAttachments(googleAttachments: googleAttachments)
    }
    
    private static func extractAttachments(_ commentables : [NSDictionary]) -> [GoogleAttachment] {
        var attachments : [GoogleAttachment] = []
        for commentable in commentables {
            let comments = commentable.object(forKey: "comments") as! [NSDictionary]
            for comment in comments {
                let googleAttachmentObjects = comment.object(forKey: "google_attachments") as! [NSDictionary]
                attachments.append(contentsOf: googleAttachmentObjects.map({ (dict) -> GoogleAttachment in
                    return GoogleAttachment(
                        id: dict.object(forKey: "id") as! Int64,
                        googleId: dict.object(forKey: "google_id") as! String,
                        googleKind: dict.object(forKey: "google_kind") as! String,
                        alternateLink: dict.object(forKey: "alternate_link") as! String,
                        title: dict.object(forKey: "title") as! String,
                        personId: dict.object(forKey: "person_id") as! Int64
                    )
                }))
            }
        }
        return attachments
    }
    
    static func reduce(googleAttachments: GoogleAttachments, action: ProjectAction) -> GoogleAttachments {
        var newAttachments = googleAttachments
        
        for result in action.results {
            if result.type == "google_attachment" {
                if (result.deleted == true) {
                    var newList = newAttachments.googleAttachments
                    newList.removeValue(forKey: result.id!)
                    newAttachments = GoogleAttachments(googleAttachments: newList)
                } else {
                    let existing = newAttachments.googleAttachments[result.id!]
                    var attrs = existing == nil ? ["id": result.id!] : serialize(attachment: existing!)
                    if (result.title != nil) {
                        attrs["title"] = result.title!
                    }
                    if (result.person_id != nil) {
                        attrs["personId"] = result.person_id!
                    }
                    if (result.google_id != nil) {
                        attrs["googleId"] = result.google_id!
                    }
                    if (result.google_kind != nil) {
                        attrs["googleKind"] = result.google_kind!
                    }
                    if (result.alternate_link != nil) {
                        attrs["alternateLink"] = result.alternate_link!
                    }
                    var newList = newAttachments.googleAttachments
                    newList[result.id!] = deserialize(dict: attrs)
                    newAttachments = GoogleAttachments(googleAttachments: newList)
                }
            }
        }
        return newAttachments
    }
    
        private static func serialize(attachment: GoogleAttachment) -> NSMutableDictionary {
            return [
                "id": attachment.id,
                "googleId": attachment.googleId,
                "googleKind": attachment.googleKind,
                "alternateLink": attachment.alternateLink,
                "title": attachment.title,
                "personId": attachment.personId
            ]
        }
    
        private static func deserialize(dict: NSDictionary) -> GoogleAttachment {
            return GoogleAttachment(
                id: dict.object(forKey: "id") as! Int64,
                googleId: dict.object(forKey: "googleId") as! String,
                googleKind: dict.object(forKey: "googleKind") as! String,
                alternateLink: dict.object(forKey: "alternateLink") as! String,
                title: dict.object(forKey: "title") as! String,
                personId: dict.object(forKey: "personId") as! Int64
            )
        }
    
    static func googleAttachments(googleAttachments: GoogleAttachments) -> [Int64 : GoogleAttachment] {
        return googleAttachments.googleAttachments;
    }
}
