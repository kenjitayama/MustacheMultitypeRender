//
//  Template.swift
//  MustacheMultitypeRender
//
//  Created by Kenji Tayama on 12/17/15.
//  Copyright © 2015 Kenji Tayama. All rights reserved.
//

import Foundation

/**
 *  Protocol for templates that renders and return a `RenderResult`, which is to be specified in the implementied classes
 */
protocol Template {

    /// generic type alias for render result
    associatedtype RenderResult
    
    /// type alias for filter function, indicated to use inside placeholders
    associatedtype Filter = (_ args: [String]) -> RenderResult // TODO: variadic parameters
    
    /// type alias for implicit filter function, for text not in placeholders
    associatedtype ImplicitFilter = (_ renderSource: String) -> RenderResult
    
    /**
     Renders the template, applying `data` to the placeholders(or arguments of filters inside them).
     
     - parameter data: data to apply to the template
     
     - returns: rendered result
     */
    func render(_ data: [String: String]?) -> RenderResult
    
    /// template string to be rendered
    var templateString: String { get }
    
    /// filter functions to render placeholders with filters
    var filters: [String: Filter] { get }
    
    /// filter function to render non-placeholder parts of the template
    var implicitFilter: ImplicitFilter? { get }
}

extension Template {

    /**
     Tokenize the whole template. Tokens correspond to placeholders and no-placeholder parts of the temlpate.
     
     - returns: array of tokens (the whole template tokenized)
     */
    func getRenderingTokens() -> [RenderingToken] {
        
        var offset = self.templateString.startIndex
        var renderingTokens = [RenderingToken]()
        
        let placeholderToken = self.getPlaceholderRenderingTokens()
        
        for placeholderToken in placeholderToken {
            
            if placeholderToken.originalRange.lowerBound != offset {

                // offset is behind the placeholder token

                let range = (offset ..< placeholderToken.originalRange.lowerBound)
                let token = RenderingToken(
                    kind: .text,
                    originalRange: range,
                    renderSource: self.templateString.substring(with: range)
                )
                renderingTokens.append(token)
            }
            
            renderingTokens.append(placeholderToken)
            offset = placeholderToken.originalRange.upperBound
        }
        
        // after the last placeholder token (or maybe no placeholder tokens)
        if offset < self.templateString.endIndex {
            let range = (offset ..< self.templateString.endIndex)
            let token = RenderingToken(
                kind: .text,
                originalRange: range,
                renderSource: self.templateString.substring(with: range)
            )
            renderingTokens.append(token)
            offset = self.templateString.endIndex
        }
        
        return renderingTokens
    }


    /**
     Get the placeholder parts of the template as tokens.
     
     - returns: placeholder parts of the template as tokens
     
     See also:
     
     - RenderingToken

     */
    private func getPlaceholderRenderingTokens() -> [RenderingToken] {
        
        let input = self.templateString
        var tokens = [RenderingToken]()
        
        Static.placeholderRegex.enumerateMatches(
            in: input,
            options: [],
            range: NSMakeRange(0, (input as NSString).length)) { (match, _, _) -> Void in
                
                guard let match = match else {
                    return
                }
                
                guard let matchRange = input.range(from: match.range),
                  let contentRange = input.range(from: match.range(at: 1)) else {
                        return
                }
                
                let contentString = input.substring(with: contentRange)
                
                let token = RenderingToken(
                    kind: .placeholder,
                    originalRange: matchRange,
                    renderSource: contentString
                )
                tokens.append(token)
        }
        
        return tokens
    }
    
}
