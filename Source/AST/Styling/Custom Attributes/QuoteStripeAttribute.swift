//
//  QuoteStripeAttrbute.swift
//  Down
//
//  Created by John Nguyen on 03.08.19.
//  Copyright © 2019 Glazed Donut, LLC. All rights reserved.
//

#if canImport(UIKit)

import Foundation
import UIKit

struct QuoteStripeAttribute {
    var color: UIColor
    var thickness: CGFloat
    var spacingAfter: CGFloat
    var locations: [CGFloat]

    var layoutWidth: CGFloat {
        return thickness + spacingAfter
    }
}

extension QuoteStripeAttribute {

    init(level: Int, color: UIColor, options: QuoteStripeOptions) {
        self.init(color: color, thickness: options.thickness, spacingAfter: options.spacingAfter, locations: [])
        locations = (0..<level).map { CGFloat($0) * layoutWidth }
    }

    func indented(by indentation: CGFloat) -> QuoteStripeAttribute {
        var copy = self
        copy.locations = locations.map { $0 + indentation }
        return copy
    }
}

extension NSAttributedString.Key {
    static let quoteStripe = NSAttributedString.Key(rawValue: "quoteStripe")
}

#endif
