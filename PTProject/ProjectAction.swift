//
//  ProjectAction.swift
//  PTProject
//
//  Created by pivotal on 6/12/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

@objc class ProjectAction : NSObject {
    let type : String
    let results : [CommandResult]
    
    @objc init(type: String, results: [CommandResult]) {
        self.type = type
        self.results = results
    }
}
