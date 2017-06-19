//
//  FileAttachments.swift
//  PTProject
//
//  Created by pivotal on 6/19/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct FileAttachments {
    let fileAttachments : [Int64 : FileAttachment];
    static func fromJSON(json: NSDictionary) -> FileAttachments {
        var fileAttachments = [Int64 : FileAttachment]()
        let stories = json.object(forKey: "stories") as! [NSDictionary]
        let epics = json.object(forKey: "epics") as! [NSDictionary]
        let list = extractAttachments(stories) + extractAttachments(epics)
        
        list.forEach { (attachment) in
            fileAttachments[attachment.id] = attachment
        }
        
        return FileAttachments(fileAttachments: fileAttachments)
    }
    
    static func reduce(fileAttachments: FileAttachments, action: ProjectAction) -> FileAttachments {
        var newAttachments = fileAttachments
        
        
        for result in action.results {
            if result.type == "file_attachment" {
                if (result.deleted == true) {
                    var newList = newAttachments.fileAttachments
                    newList.removeValue(forKey: result.id!)
                    newAttachments = FileAttachments(fileAttachments: newList)
                } else {
                    let existing = newAttachments.fileAttachments[result.id!];
                    var attrs = existing == nil ? ["id": result.id!] : serialize(attachment: existing!);
                    if (result.filename != nil) {
                        attrs["filename"] = result.filename!
                    }
                    if (result.uploader_id != nil) {
                        attrs["uploaderId"] = result.uploader_id!
                    }
                    if (result.download_url != nil) {
                        attrs["downloadUrl"] = result.download_url!
                    }
                    if (result.thumbnail_url != nil) {
                        attrs["thumbnailUrl"] = result.thumbnail_url!
                    }
                    if (result.big_url != nil) {
                        attrs["bigUrl"] = result.big_url!
                    }
                    var newList = newAttachments.fileAttachments
                    newList[result.id!] = deserialize(dict: attrs)
                    newAttachments = FileAttachments(fileAttachments: newList)
                }
            }
        }
        
        return newAttachments
    }
    
    private static func extractAttachments(_ commentables : [NSDictionary]) -> [FileAttachment] {
        var attachments : [FileAttachment] = []
        for commentable in commentables {
            let comments = commentable.object(forKey: "comments") as! [NSDictionary]
            for comment in comments {
                let fileAttachmentObjects = comment.object(forKey: "file_attachments") as! [NSDictionary]
                attachments.append(contentsOf: fileAttachmentObjects.map({ (dict) -> FileAttachment in
                    return FileAttachment(
                        id: dict.object(forKey: "id") as! Int64,
                        filename: dict.object(forKey: "filename") as! String,
                        uploaderId: dict.object(forKey: "uploader_id") as! Int64,
                        downloadUrl: dict.object(forKey: "download_url") as! String?,
                        thumbnailUrl: dict.object(forKey: "thumbnail_url") as! String?,
                        bigUrl: dict.object(forKey: "big_url") as! String?
                    )
                }))
            }
        }
        return attachments
    }
    
    private static func serialize(attachment: FileAttachment) -> NSMutableDictionary {
        return [
            "id": attachment.id,
            "filename": attachment.filename,
            "uploaderId": attachment.uploaderId,
            "downloadUrl": attachment.downloadUrl as Any,
            "thumbnailUrl": attachment.thumbnailUrl as Any,
            "bigUrl": attachment.bigUrl as Any
        ]
    }

    private static func deserialize(dict: NSDictionary) -> FileAttachment {
        return FileAttachment(
            id: dict.object(forKey: "id") as! Int64,
            filename: dict.object(forKey: "filename") as! String,
            uploaderId: dict.object(forKey: "uploaderId") as! Int64,
            downloadUrl: dict.object(forKey: "downloadUrl") as! String?,
            thumbnailUrl: dict.object(forKey: "thumbnailUrl") as! String?,
            bigUrl: dict.object(forKey: "bigUrl") as! String?
        )
    }
    
    static func fileAttachments(fileAttachments: FileAttachments) -> [Int64 : FileAttachment] {
        return fileAttachments.fileAttachments;
    }
}
