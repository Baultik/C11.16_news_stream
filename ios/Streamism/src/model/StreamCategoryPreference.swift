//
//  StreamCategoryPreference.swift
//  Streamism
//
//  Created by Brian Ault on 8/23/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import Foundation

struct StreamCategoryPreference {
    
    public static let all = [StreamCategoryType.Gaming,
                         StreamCategoryType.Entertainment,
                         StreamCategoryType.People,
                         StreamCategoryType.News,
                         StreamCategoryType.Sports,
                         StreamCategoryType.Misc]
    
    private var prefs = StreamCategoryPreference.all
    
    func hasType(type:StreamCategoryType) -> Bool {
        return prefs.contains(type)
    }
    
    mutating func addType(type:StreamCategoryType) {
        if !prefs.contains(type) {
            prefs.append(type)
        }
    }
    
    mutating func removeType(type:StreamCategoryType) {
        if prefs.contains(type), let i = prefs.index(of: type) {
            prefs.remove(at: i)
        }
    }
    
    mutating func setTypes(types:[StreamCategoryType]) {
        prefs.removeAll()
        for type in types {
            addType(type: type)
        }
    }
}
