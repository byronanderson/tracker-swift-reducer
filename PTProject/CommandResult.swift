//
//  CommandResult.swift
//  PTProject
//
//  Created by pivotal on 6/15/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct CommandResult {
    let id : Int64?
    let deleted : Bool?
    let type : String
    let name : String?
    let iteration_length : Int?
    let start_time : Int64?
    let bugs_and_chores_are_estimatable : Bool?
    let time_zone : NSDictionary?
    let point_scale : String?
    let description : String?
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
}
