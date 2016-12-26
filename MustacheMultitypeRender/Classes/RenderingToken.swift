//
//  RenderingToken.swift
//  MustacheMultitypeRender
//
//  Created by Kenji Tayama on 12/17/15.
//  Copyright © 2015 Kenji Tayama. All rights reserved.
//

import Foundation

/// Represents a token (parts of the temlpate) to be rendered
final class RenderingToken {

    /**
     Type of the token.
     
     - Placeholder: placeholder part of the temlpate
     - Text:        non-placeholder part of the temlpate
     */
    enum Kind {
        case placeholder
        case text
    }
    
    /// type of this token
    let kind: Kind
    
    /// Range of the token. Before rendering and including placeholder symbols.
    let originalRange: Range<String.Index>
    
    /// Text to be handled and rendered. Placeholder symbols excluded and filter function included.
    let renderSource: String
    
    /// name of the filter function, if indicated in the placeholer
    let filterName: String?
    
    /// arguments for the filter function, if any
    let filterArgs: [String]?
    
    /**
     Parses the `renderSource` for a filter function, and returns a renderingToken
     
     - parameter kind:          type of the token
     - parameter originalRange: range of the token
     - parameter renderSource:  text to be handled and rendered
     
     - returns: a new RenderingToken
     */
    init(kind: Kind, originalRange: Range<String.Index>, renderSource: String) {
        
        self.kind = kind
        self.originalRange = originalRange
        self.renderSource = renderSource


        guard kind == .placeholder else {
            self.filterName = nil
            self.filterArgs = nil
            return
        }
        
        let matches = Static.filterRegex.matches(
            in: renderSource,
            options: [],
            range: NSMakeRange(0, (renderSource as NSString).length))
        

        guard let match = matches.first else {
            self.filterName = nil
            self.filterArgs = nil
            return
        }
        
        guard let filterNameRange = renderSource.range(from: match.rangeAt(1)),
            let filterArgsStrRange = renderSource.range(from: match.rangeAt(2)) else {
                self.filterName = nil
                self.filterArgs = nil
                return
        }
        
        self.filterName = renderSource.substring(with: filterNameRange)
        
        let filterArgsStr = renderSource.substring(with: filterArgsStrRange)
        let separatorSet = CharacterSet(charactersIn: ", ")
        self.filterArgs = (filterArgsStr as NSString).components(separatedBy: separatorSet)
    }
    
}
