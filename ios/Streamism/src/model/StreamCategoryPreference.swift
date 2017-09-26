//
//  StreamCategoryPreference.swift
//  Streamism
//
//  Created by Brian Ault on 8/23/17.
//  Copyright © 2017 Brian Ault. All rights reserved.
//

import Foundation

struct StreamCategoryPreference {
    
    private var prefs = [StreamCategoryType]()
    
    public static func all() -> StreamCategoryPreference {
        var prefs = StreamCategoryPreference()
        prefs.setTypes([StreamCategoryType.Gaming,
                               StreamCategoryType.Entertainment,
                               StreamCategoryType.People,
                               StreamCategoryType.News,
                               StreamCategoryType.Sports,
                               StreamCategoryType.Misc])
        return prefs
    }
    
    func hasType(_ type:StreamCategoryType) -> Bool {
        return prefs.contains(type)
    }
    
    mutating func addType(_ type:StreamCategoryType) {
        if !prefs.contains(type) {
            prefs.append(type)
        }
    }
    
    mutating func removeType(_ type:StreamCategoryType) {
        if prefs.contains(type), let i = prefs.index(of: type) {
            prefs.remove(at: i)
        }
    }
    
    mutating func setTypes(_ types:[StreamCategoryType]) {
        prefs.removeAll()
        for type in types {
            addType(type)
        }
    }
}
