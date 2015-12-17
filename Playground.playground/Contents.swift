//: Playground - noun: a place where people can play

import UIKit
import MustacheMultitypeRender

let filters: [String: TemplateAttributedStringRender.Filter] = [
    "boldBig": { (args: [String]) in
        
        return NSAttributedString(
            string: args[0],
            attributes: [
                NSFontAttributeName: UIFont.boldSystemFontOfSize(30)
            ])
    }
]

let implicitFilter: TemplateAttributedStringRender.ImplicitFilter = { (renderSource: String) in
    
    return NSAttributedString(
        string: renderSource,
        attributes: [
            NSFontAttributeName: UIFont.italicSystemFontOfSize(UIFont.systemFontSize())
        ])
}

var template = TemplateAttributedStringRender(
    templateString: "Lets get {{boldBig(emotion)}} with {{fruit}}",
    filters: filters,
    implicitFilter: implicitFilter)

let attrStr = template.render([
    "emotion": "happy",
    "fruit": "apple"
    ])

let label = UILabel(frame: CGRectMake(0, 0, 300, 100))
label.backgroundColor = UIColor.whiteColor()
label.attributedText = attrStr


label
