//: Playground - noun: a place where people can play

import UIKit
import MustacheMultitypeRender

let filters: [String: TemplateAttributedStringRender.Filter] = [
    "boldBig": { (args: [String]) in
        
        return NSAttributedString(
            string: args[0],
            attributes: [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 30)
            ])
    }
]

let implicitFilter: TemplateAttributedStringRender.ImplicitFilter = { (renderSource: String) in
    
    return NSAttributedString(
        string: renderSource,
        attributes: [
            NSFontAttributeName: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)
        ])
}

var template = TemplateAttributedStringRender(
    templateString: "Lets eat a {{boldBig(adjetive)}} {{fruit}}",
    filters: filters,
    implicitFilter: implicitFilter)

let attrStr = template.render([
    "adjetive": "tasty",
    "fruit": "apple"
    ])

let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
label.backgroundColor = UIColor.white
label.attributedText = attrStr


label
