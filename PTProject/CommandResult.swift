//
//  CommandResult.swift
//  PTProject
//
//  Created by pivotal on 6/15/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct CommandResult {
    let type : String
    let name : String?
    let iteration_length : Int?
    let start_time : Int64?
    let bugs_and_chores_are_estimatable : Bool?
    let time_zone : NSDictionary?
}
