//
//  CommandResult.swift
//  PTProject
//
//  Created by pivotal on 6/15/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

@objc class CommandResult : NSObject {
    let id : Int64?
    let deleted : Bool?
    let type : String
    let name : String?
    let iteration_length : Int?
    let start_time : Int64?
    let bugs_and_chores_are_estimatable : Bool?
    let time_zone : NSDictionary?
    let point_scale : String?
    let desc : String?
    let label_id : Int64?
    let after_id : Int64?
    let before_id : Int64?
    let estimate : Int?
    let current_state : String?
    let story_type : String?
    let moved : Bool?
    let complete : Bool?
    let story_id : Int64?
    let position : Int?
    let epic_id: Int64?
    let text : String?
    let person_id : Int64?
    let file_attachment_ids : [Int64]?
    let google_attachment_ids : [Int64]?
    let number : Int?
    let team_strength : Double?
    let length : Int?
    let default_length : Bool?
    let filename : String?
    let download_url : String?
    let thumbnail_url : String?
    let big_url : String?
    let uploader_id : Int64?
    let alternate_link : String?
    let google_id : String?
    let google_kind : String?
    let title : String?
    let role : String?
    let username : String?
    let initials : String?
    
    init(id: Int64?, deleted: Bool?, type: String, name: String?, iteration_length: Int?, start_time: Int64?, bugs_and_chores_are_estimatable: Bool?, time_zone: NSDictionary?, point_scale: String?, description: String?, label_id: Int64?, after_id: Int64?, before_id: Int64?, estimate: Int?, current_state: String?, story_type: String?, moved: Bool?, complete: Bool?, story_id: Int64?, position: Int?, epic_id: Int64?, text: String?, person_id: Int64?, file_attachment_ids: [Int64]?, google_attachment_ids: [Int64]?, number: Int?, team_strength: Double?, length: Int?, default_length: Bool?, filename: String?, download_url: String?, thumbnail_url: String?, big_url: String?, uploader_id: Int64?, alternate_link: String?, google_id: String?, google_kind: String?, title: String?, role: String?, username: String?, initials: String?) {
        self.id = id
        self.deleted = deleted
        self.type = type
        self.name = name
        self.iteration_length = iteration_length
        self.start_time = start_time
        self.bugs_and_chores_are_estimatable = bugs_and_chores_are_estimatable
        self.time_zone = time_zone
        self.point_scale = point_scale
        self.desc = description
        self.label_id = label_id
        self.after_id = after_id
        self.before_id = before_id
        self.estimate = estimate
        self.current_state = current_state
        self.story_type = story_type
        self.moved = moved
        self.complete = complete
        self.story_id = story_id
        self.position = position
        self.epic_id = epic_id
        self.text = text
        self.person_id = person_id
        self.file_attachment_ids = file_attachment_ids
        self.google_attachment_ids = google_attachment_ids
        self.number = number
        self.team_strength = team_strength
        self.length = length
        self.default_length = default_length
        self.filename = filename
        self.download_url = download_url
        self.thumbnail_url = thumbnail_url
        self.big_url = big_url
        self.uploader_id = uploader_id
        self.alternate_link = alternate_link
        self.google_id = google_id
        self.google_kind = google_kind
        self.title = title
        self.role = role
        self.username = username
        self.initials = initials
    }
}
