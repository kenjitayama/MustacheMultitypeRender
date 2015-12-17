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
    typealias RenderResult
    
    /// type alias for filter function, indicated to use inside placeholders
    typealias Filter = (args: [String]) -> RenderResult // TODO: variadic parameters
    
    /// type alias for implicit filter function, for text not in placeholders
    typealias ImplicitFilter = (renderSource: String) -> RenderResult
    
    /**
     Renders the template, applying `data` to the placeholders(or arguments of filters inside them).
     
     - parameter data: data to apply to the template
     
     - returns: rendered result
     */
    func render(data: [String: String]) -> RenderResult
    
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
        
        let mustacheTokens = self.getMustacheRenderingTokens()
        
        for mToken in mustacheTokens {
            
            if mToken.originalRange.startIndex != offset {

                // offset is behind the mustache token

                let range = Range<String.Index>(
                    start: offset,
                    end: mToken.originalRange.startIndex
                )
                let token = RenderingToken(
                    kind: .Text,
                    originalRange: range,
                    renderSource: self.templateString.substringWithRange(range)
                )
                renderingTokens.append(token)
            }
            
            renderingTokens.append(mToken)
            offset = mToken.originalRange.endIndex
        }
        
        // after the last mustache token (or maybe no mustache tokens)
        if offset < self.templateString.endIndex {
            let range = Range<String.Index>(
                start: offset,
                end: self.templateString.endIndex
            )
            let token = RenderingToken(
                kind: .Text,
                originalRange: range,
                renderSource: self.templateString.substringWithRange(range)
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
    private func getMustacheRenderingTokens() -> [RenderingToken] {
        
        let input = self.templateString
        var tokens = [RenderingToken]()
        
        Static.mustacheRegex.enumerateMatchesInString(
            input,
            options: [],
            range: NSMakeRange(0, (input as NSString).length)) { (match, _, _) -> Void in
                
                guard let match = match else {
                    return
                }
                
                guard let matchRange = Static.rangeFromNSRange(match.range, forString: input),
                    let contentRange = Static.rangeFromNSRange(match.rangeAtIndex(1), forString: input) else {
                        return
                }
                
                let contentString = input.substringWithRange(contentRange)
                
                let token = RenderingToken(
                    kind: .Placeholder,
                    originalRange: matchRange,
                    renderSource: contentString
                )
                tokens.append(token)
        }
        
        return tokens
    }
    
}
