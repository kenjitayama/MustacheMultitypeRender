//
//  TemplateAttributedStringFallbackRender.swift
//  Couples
//
//  Created by Kenji Tayama on 2015/12/21.
//  Copyright © 2015年 eureka. All rights reserved.
//

import Foundation

public final class TemplateAttributedStringFallbackRender: Template {
 
    public typealias RenderResult = AnyObject
    public typealias Filter = (args: [String]) -> RenderResult
    public typealias ImplicitFilter = (renderSource: String) -> RenderResult
    
    public func render(data: [String: String]? = nil) -> RenderResult {

        let renderedTokens = self.getRenderingTokens().map { (token) -> RenderResult in
            return self.renderToken(token, data: data ?? [String: String]())
        }
        

        var hasAttributed = false
        for renderedToken in renderedTokens {
            if let _ = renderedToken as? NSAttributedString {
                hasAttributed = true
            }
        }
        
        if hasAttributed {

            let mutableAttrStr = NSMutableAttributedString()
            
            for renderedToken in renderedTokens {

                if let attrStr = renderedToken as? NSAttributedString {

                    mutableAttrStr.appendAttributedString(attrStr)
                    
                } else if let str = renderedToken as? String {
                    
                    if let filter = self.implicitFilter,
                        let attrStr = filter(renderSource: str) as? NSAttributedString {
                            
                            mutableAttrStr.appendAttributedString(attrStr)
                            
                    } else {
                        mutableAttrStr.appendAttributedString(NSAttributedString(string: str))
                    }
                }
            }
            
            return NSAttributedString(attributedString: mutableAttrStr)
            
        } else if let strings = renderedTokens as? [String] {
            
            let string = strings.joinWithSeparator("")
            
            if self.ignoreImplicitIfNoExplicitFiltered {
               return string
            }
            
            if let filter = self.implicitFilter,
                let attrStr = filter(renderSource: string) as? NSAttributedString {
                    
                    return attrStr
            }
            return string
        }
        
        return ""
    }
    
    public init(templateString: String,
        ignoreImplicitIfNoExplicitFiltered: Bool,
        filters: [String: Filter],
        implicitFilter: ImplicitFilter? = nil) {
            

            self.templateString = templateString
            self.ignoreImplicitIfNoExplicitFiltered = ignoreImplicitIfNoExplicitFiltered
            self.filters = filters
            self.implicitFilter = implicitFilter
    }
    
    // MARK: internal
    
    let templateString: String
    let ignoreImplicitIfNoExplicitFiltered: Bool
    let filters: [String: Filter]
    let implicitFilter: ImplicitFilter?
    
    
    /**
     Renders a token, which corrensponds to a placeholder or a non-placeholder part in the template
     
     - parameter token: the token to render
     - parameter data: data to apply to the token
     
     - returns: rendered result
     */
    private func renderToken(token: RenderingToken, data: [String: String]) -> RenderResult {
        
        switch token.kind {
            
        case .Placeholder:
            
            if let filterName = token.filterName,
                let filter = self.filters[filterName] {
                    
                    var replacedFilterArgs = [String]()
                    if let args = token.filterArgs {
                        for arg in args {
                            replacedFilterArgs.append(data[arg] ?? arg)
                        }
                    }
                    return filter(args: replacedFilterArgs)
            }
            
            let renderSource = data[token.renderSource] ?? token.renderSource
            if let filter = self.implicitFilter {
                return filter(renderSource: renderSource)
            }
            return renderSource
            
        case .Text:
            
            fallthrough
        default:
            
//            if let filter = self.implicitFilter {
//                return filter(renderSource: token.renderSource)
//            }
            return token.renderSource
        }
    }

}