//
//  Static.swift
//  MustacheMultitypeRender
//
//  Created by Kenji Tayama on 12/17/15.
//  Copyright © 2015 Kenji Tayama. All rights reserved.
//

import Foundation

/**
 *  Static constants and functions
 */
struct Static {
    
    /// regular expression for tokenizing placeholder parts of a template
    static let placeholderRegex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "\\{\\{(.+?)\\}\\}", options: [])
    }()
    
    /// regular expression for parsing a filter funciton inside a placeholder
    static let filterRegex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "(.+?)\\((.+?)\\)", options: [])
    }()
}

