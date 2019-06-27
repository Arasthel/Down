//
//  NSMutableAttributedString+Attributes.swift
//  Down
//
//  Created by John Nguyen on 22.06.19.
//  Copyright © 2019 Glazed Donut, LLC. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {

    func setAttributes(_ attrs: Attributes) {
        setAttributes(attrs, range: wholeRange)
    }

    func addAttributes(_ attrs: Attributes) {
        addAttributes(attrs, range: wholeRange)
    }

    func addAttribute(_ name: NSAttributedString.Key, value: Any) {
        addAttribute(name, value: value, range: wholeRange)
    }

    func removeAttribute(_ name: NSAttributedString.Key) {
        removeAttribute(name, range: wholeRange)
    }

    func replaceAttribute(_ name: NSAttributedString.Key, value: Any) {
        removeAttribute(name)
        addAttribute(name, value: value)
    }

    func updateAttribute<A>(_ key: NSAttributedString.Key, with f: (A) -> A) {
        updateAttribute(key, inRange: wholeRange, with: f)
    }

    func updateAttribute<A>(_ key: NSAttributedString.Key, inRange range: NSRange, with f: (A) -> A) {
        var exisitngValues = [(value: A, range: NSRange)]()

        enumerateAttribute(key, in: range, options: []) { value, range, _ in
            if let value = value as? A {
                exisitngValues.append((value, range))
            }
        }

        exisitngValues.forEach { addAttribute(key, value: f($0.0), range: $0.1) }
    }
}
