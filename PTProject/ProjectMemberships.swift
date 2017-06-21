//
//  ProjectMemberships.swift
//  PTProject
//
//  Created by pivotal on 6/19/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct ProjectMemberships {
    let memberships : [ProjectMembership]
    
    static func fromJSON(json: NSDictionary) -> ProjectMemberships {
        let membershipObjects = json.object(forKey: "memberships") as! [NSDictionary]
        let memberships = membershipObjects.filter({ (dict) -> Bool in
            return dict.object(forKey: "id") != nil
        }).map({ (dict) -> ProjectMembership in
            let id = dict.object(forKey: "id") as! Int64
            let role = dict.object(forKey: "role") as! String
            let person = dict.object(forKey: "person") as! NSDictionary
            let personId = person.object(forKey: "id") as! Int64
            let personName = person.object(forKey: "name") as! String
            let personInitials = person.object(forKey: "initials") as! String
            let personUsername = person.object(forKey: "username") as! String
            return ProjectMembership(id: id, role: role, personId: personId, personName: personName, personInitials: personInitials, personUsername: personUsername)
        })
        return ProjectMemberships(memberships: memberships)
    }
    
    static func reduce(memberships: ProjectMemberships, action: ProjectAction) -> ProjectMemberships {
        var newMemberships = memberships
        
        for result in action.results {
            if result.type == "person" {
                let existing = newMemberships.memberships.first(where: { (membership) -> Bool in
                    return membership.personId == result.id!
                })
                if existing != nil {
                    let attrs = serialize(membership: existing!)
                    if result.name != nil {
                        attrs["personName"] = result.name!
                    }
                        
                    if result.username != nil {
                        attrs["personUsername"] = result.username!
                    }
                    
                    if result.initials != nil {
                        attrs["personInitials"] = result.initials
                    }
                    var newList = newMemberships.memberships
                    newList.append(deserialize(dict: attrs))
                    newMemberships = ProjectMemberships(memberships: newList)
                }
            }
            
            if result.type == "project_membership" {
                let existing = findMembershipWithId(newMemberships, result.id!)
                if result.deleted == true {
                    let newList = newMemberships.memberships.filter({ (membership) -> Bool in
                        return membership.id != result.id!
                    })
                    newMemberships = ProjectMemberships(memberships: newList)
                } else {
                    let attrs = existing == nil ? ["id": result.id!] : serialize(membership: existing!)
                    var newList = newMemberships.memberships.filter({ (membership) -> Bool in
                        return membership.id != result.id!
                    })
                    if result.role != nil {
                        attrs["role"] = result.role!
                    }
                    if result.person_id != nil {
                        attrs["personId"] = result.person_id!
                        
                        let personResult = action.results.first(where: { (otherResult) -> Bool in
                            return otherResult.type == "person" && otherResult.id == result.person_id
                        })
                        
                        if personResult != nil {
                            if personResult!.name != nil {
                                attrs["personName"] = personResult!.name!
                            }
                            
                            if personResult!.username != nil {
                                attrs["personUsername"] = personResult!.username!
                            }
                            
                            if personResult!.initials != nil {
                                attrs["personInitials"] = personResult!.initials
                            }
                        }
                    }
                    newList.append(deserialize(dict: attrs))
                    newMemberships = ProjectMemberships(memberships: newList)
                }
            }
        }
        
        return newMemberships
    }
    
    private static func findMembershipWithId(_ memberships: ProjectMemberships, _ id: Int64) -> ProjectMembership? {
        return memberships.memberships.first(where: { (membership) -> Bool in
            return membership.id == id
        })
    }
    
    private static func serialize(membership: ProjectMembership) -> NSMutableDictionary {
        return [
            "id": membership.id,
            "role": membership.role,
            "personId": membership.personId,
            "personName": membership.personName,
            "personInitials": membership.personInitials,
            "personUsername": membership.personUsername
        ]
    }
    
    private static func deserialize(dict: NSDictionary) -> ProjectMembership {
        return ProjectMembership(
            id: dict.object(forKey: "id") as! Int64,
            role: dict.object(forKey: "role") as! String,
            personId: dict.object(forKey: "personId") as! Int64,
            personName: dict.object(forKey: "personName") as! String,
            personInitials: dict.object(forKey: "personInitials") as! String,
            personUsername: dict.object(forKey: "personUsername") as! String
        )
    }
    
    static func activeMemberships(memberships: ProjectMemberships) -> [ProjectMembership] {
        return memberships.memberships
    }
}
