//
//  TemplateAttributedStringRender.swift
//  MustacheMultitypeRender
//
//  Created by Kenji Tayama on 12/17/15.
//  Copyright © 2015 Kenji Tayama. All rights reserved.
//

import Foundation

/// A Template that renders as `NSAttributedString`
public final class TemplateAttributedStringRender: Template {
    
    // MARK: Public
    
    public typealias RenderResult = NSAttributedString
    public typealias Filter = (_ args: [String]) -> RenderResult
    public typealias ImplicitFilter = (_ renderSource: String) -> RenderResult
    
    public func render(_ data: [String: String]? = nil) -> RenderResult {
        let renderedTokens = self.getRenderingTokens().map { (token) -> RenderResult in
            return self.renderToken(token, data: data ?? [String: String]())
        }
        
        let attributedString = NSMutableAttributedString()
        
        for renderedToken in renderedTokens {
            attributedString.append(renderedToken)
        }
       
        return NSAttributedString(attributedString: attributedString)
    }

    public init(templateString: String, filters: [String: Filter], implicitFilter: ImplicitFilter? = nil) {
        self.templateString = templateString
        self.filters = filters
        self.implicitFilter = implicitFilter
    }

    // MARK: internal
    
    let templateString: String
    let filters: [String: Filter]
    let implicitFilter: ImplicitFilter?
    
    
    /**
     Renders a token, which corrensponds to a placeholder or a non-placeholder part in the template
     
     - parameter token: the token to render
     - parameter data: data to apply to the token
     
     - returns: rendered result
     */
    private func renderToken(_ token: RenderingToken, data: [String: String]) -> RenderResult {
        
        switch token.kind {
            
        case .placeholder:
            
            if let filterName = token.filterName,
                let filter = self.filters[filterName] {
                    
                    var replacedFilterArgs = [String]()
                    if let args = token.filterArgs {
                        for arg in args {
                            replacedFilterArgs.append(data[arg] ?? arg)
                        }
                    }
                    return filter(replacedFilterArgs)
            }
            
            let renderSource = data[token.renderSource] ?? token.renderSource
            if let filter = self.implicitFilter {
                return filter(renderSource)
            }
            return NSAttributedString(string: renderSource)
            
        case .text:
            
            fallthrough
        default:
            
            if let filter = self.implicitFilter {
                return filter(token.renderSource)
            }
            return NSAttributedString(string: token.renderSource)
        }
    }
}
