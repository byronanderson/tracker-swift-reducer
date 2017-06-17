//
//  StoryIds.swift
//  PTProject
//
//  Created by pivotal on 6/15/17.
//  Copyright © 2017 pivotaltracker. All rights reserved.
//

import Foundation

struct StoryIds {
    let storyIds : [Int64]
    
    static func fromJSON(json: NSDictionary) -> StoryIds {
        let storyObjects = json.object(forKey: "stories") as! [NSDictionary]
        let storyIds = storyObjects.map { (dict) -> Int64 in
            return dict.object(forKey: "id") as! Int64
        }
        return StoryIds(storyIds: storyIds)
    }
    
    static func reduce(storyIds: StoryIds, action: ProjectAction) -> StoryIds {
        let storyResults = action.results.filter { (result) -> Bool in
            return result.type == "story"
        }
        if (storyIds.storyIds.count == 0 && storyResults.count > 0) {
            let theBlock = findMoveBlocks(storyResults: storyResults)[0];
            return StoryIds(storyIds: ids(storyResults: theBlock));
        } else if (action.type == "multi_story_move_into_project") {
            return moveStoriesAroundInManyChunks(storyIds: storyIds, storyResults: storyResults)
        } else if (isMoving(action: action)) {
            return moveStoriesAroundInOneChunk(storyIds: storyIds, storyResults: storyResults)
        } else {
            return handleRemovals(storyIds: storyIds, storyResults: storyResults);
        }
    }
    
    private static func moveStoriesAroundInManyChunks(storyIds: StoryIds, storyResults: [CommandResult]) -> StoryIds {
        var newStoryIds = storyIds
        for chunk in findMoveBlocks(storyResults: storyResults) {
            newStoryIds = moveStoriesAroundInOneChunk(storyIds: newStoryIds, storyResults: chunk)
        }
        return newStoryIds
    }
    
    private static func findMoveBlocks(storyResults: [CommandResult]) -> [[CommandResult]] {
        var chunk = [storyResults.first!]
        if (storyResults.count == 1) {
            return [chunk]
        }
        var results = Array(storyResults[1...(storyResults.count - 1)])
        var done = false
        while !done {
            let previousStory = findResultWithBeforeId(results: results, id: chunk[0].id!)
            let nextStory = findResultWithAfterId(results: results, id: chunk[chunk.count - 1].id!)
            if (previousStory != nil) {
                chunk.insert(previousStory!, at: 0)
                results = results.filter({ (result) -> Bool in
                    return result.id! != previousStory!.id!
                })
            }
            if (nextStory != nil) {
                chunk.append(nextStory!)
                results = results.filter({ (result) -> Bool in
                    return result.id! != nextStory!.id!
                })

            }
            done = previousStory == nil && nextStory == nil
        }
        if results.count == 0 {
            return [chunk]
        } else {
            let rest = findMoveBlocks(storyResults: results)
            var retVal : [[CommandResult]] = []
            retVal.append(chunk)
            retVal.append(contentsOf: rest)
            return retVal
        }
    }
    
    private static func findResultWithAfterId(results: [CommandResult], id: Int64) -> CommandResult? {
        for result in results {
            if id == result.after_id {
                return result
            }
        }
        return nil
    }
    
    private static func findResultWithBeforeId(results: [CommandResult], id: Int64) -> CommandResult? {
        for result in results {
            if id == result.before_id {
                return result
            }
        }
        return nil
    }
    
    private static func sortResults(storyResults: [CommandResult], storyIds: StoryIds) -> [CommandResult] {
        return storyResults.sorted(by: { (one, two) -> Bool in
            let indexOne = storyIds.storyIds.index(of: one.id!) ?? -1
            let indexTwo = storyIds.storyIds.index(of: two.id!) ?? -1
            return (indexOne - indexTwo) < 0
        })
    }
    
    private static func moveStoriesAroundInOneChunk(storyIds: StoryIds, storyResults: [CommandResult]) -> StoryIds {
        let sortedResults = sortResults(storyResults: storyResults, storyIds: storyIds)
        let extractedIds = ids(storyResults: sortedResults)
        let omitted = omitIds(storyIds: storyIds.storyIds, ids: extractedIds)
        let firstResult = sortedResults.first!
        if firstResult.after_id != nil {
            let afterIndex = omitted.index(of: firstResult.after_id!)
            if afterIndex != nil {
                var newList = omitted
                newList.insert(contentsOf: extractedIds, at: afterIndex! + 1)
                return StoryIds(storyIds: newList)
            }
        }
        let lastResult = sortedResults.last!
        if lastResult.before_id != nil {
            let beforeIndex = omitted.index(of: lastResult.before_id!)
            if beforeIndex != nil {
                var newList = omitted
                newList.insert(contentsOf: extractedIds, at: beforeIndex!)
                return StoryIds(storyIds: newList)
            }
        }
        return storyIds
    }
    
    private static func omitIds(storyIds: [Int64], ids: [Int64]) -> [Int64] {
        return storyIds.filter({ (id) -> Bool in
            return !ids.contains(id)
        })
    }

    private static func ids(storyResults: [CommandResult]) -> [Int64] {
        return storyResults.map { (result) -> Int64 in
            result.id!
        }
    }

    private static func handleRemovals(storyIds: StoryIds, storyResults: [CommandResult]) -> StoryIds {
        var newStoryIds = storyIds;
        storyResults.forEach { (result) in
            if (result.deleted == true || result.moved == true) {
                var newList = newStoryIds.storyIds
                
                let index = newList.index(of: result.id!)
                if (index != nil) {
                    newList.remove(at: index!)
                    newStoryIds = StoryIds(storyIds: newList)
                }
            }
        }
        return newStoryIds;
    }
    
    private static func isMoving(action: ProjectAction) -> Bool {
        for result in action.results {
            // hasOwnProperty???
            if (result.type == "story" && (result.after_id != nil || result.before_id != nil)) {
                return true
            }
        }
        return false
    }


    static func storyIds(storyIds: StoryIds) -> [Int64] {
        return storyIds.storyIds
    }
}
