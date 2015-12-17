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
    static let mustacheRegex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "\\{\\{(.+?)\\}\\}", options: [])
    }()
    
    /// regular expression for parsing a filter funciton inside a placeholder
    static let filterRegex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "(.+?)\\((.+?)\\)", options: [])
    }()
    
    
    /**
     Helper function for converting NSRange to Swift Range.
     
     - parameter nsRange: a NSRange
     - parameter str:     the string that contains the nsRange
     
     - returns: Swift Range that corresponds to `nsRange`
     */
    static func rangeFromNSRange(nsRange: NSRange, forString str: String) -> Range<String.Index>? {
        let fromUTF16 = str.utf16.startIndex.advancedBy(nsRange.location, limit: str.utf16.endIndex)
        let toUTF16 = fromUTF16.advancedBy(nsRange.length, limit: str.utf16.endIndex)
        
        
        if let from = String.Index(fromUTF16, within: str),
            let to = String.Index(toUTF16, within: str) {
                return from ..< to
        }
        
        return nil
    }
    
}

