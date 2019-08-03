//
//  DefaultStyler.swift
//  Down
//
//  Created by John Nguyen on 22.06.19.
//  Copyright © 2019 Glazed Donut, LLC. All rights reserved.
//

#if canImport(UIKit)

import Foundation
import UIKit

open class DefaultStyler: Styler {

    public var fonts: FontCollection = .dynamicFonts
    public var colors: ColorCollection = .init()
    public var paragraphStyles: ParagraphStyleCollection = .init()

    private var listPrefixAttributes: [NSAttributedString.Key : Any] {[
        .font: fonts.listItemPrefix,
        .foregroundColor: colors.listItemPrefix]
    }

    let itemParagraphStyler: ListItemParagraphStyler

    public init(listItemOptions: ListItemOptions) {
        // TODO: Can we not assume there is a period?
        let widthOfPeriod = NSAttributedString(string: ".", attributes: [.font: fonts.listItemPrefix]).size().width
        let maxPrefixWidth = fonts.listItemPrefix.widthOfLargestDigit * CGFloat(listItemOptions.maxPrefixDigits)
        let maxPrefixWidthIncludingPeriod = maxPrefixWidth + widthOfPeriod

        itemParagraphStyler = ListItemParagraphStyler(options: listItemOptions, largestPrefixWidth: maxPrefixWidthIncludingPeriod)
    }
}

// MARK: - Styling

extension DefaultStyler {

    open func style(document str: NSMutableAttributedString) {

    }

    open func style(blockQuote str: NSMutableAttributedString) {
        str.setAttributes([
            .font: fonts.quote,
            .foregroundColor: colors.quote,
            .paragraphStyle: paragraphStyles.quote])
    }

    open func style(list str: NSMutableAttributedString, nestDepth: Int) {

    }

    open func style(listItemPrefix str: NSMutableAttributedString) {
        str.setAttributes(listPrefixAttributes)
    }

    open func style(item str: NSMutableAttributedString, prefixLength: Int, nestDepth: Int) {
        // For simplicity, let's assume that there is no nested list directly after the prefix.
        // TODO: handle this case.

        let paragraphRanges = str.paragraphRangesExcludingLists()
        guard let leadingParagraphRange = paragraphRanges.first else { return }
        
        let attributedPrefix = str.prefix(with: prefixLength)
        let prefixWidth = attributedPrefix.size().width
        let leadingParagraphStyle = itemParagraphStyler.leadingParagraphStyle(nestDepth: nestDepth, prefixWidth: prefixWidth)
        str.addAttribute(.paragraphStyle, value: leadingParagraphStyle, range: leadingParagraphRange)

        for range in paragraphRanges.dropFirst() {
            let paragraphStyle = itemParagraphStyler.trailingParagraphStyle(nestDepth: nestDepth)
            str.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        }
    }

    open func style(codeBlock str: NSMutableAttributedString, fenceInfo: String?) {
        str.setAttributes([
            .font: fonts.code,
            .foregroundColor: colors.code,
            .paragraphStyle: paragraphStyles.code])
    }

    open func style(htmlBlock str: NSMutableAttributedString) {
        str.setAttributes([
            .font: fonts.code,
            .foregroundColor: colors.code,
            .paragraphStyle: paragraphStyles.code])
    }

    open func style(customBlock str: NSMutableAttributedString) {
        // Not supported.
    }

    open func style(paragraph str: NSMutableAttributedString,  isTopLevel: Bool) {
        guard isTopLevel else { return }
        str.addAttribute(.paragraphStyle, value: paragraphStyles.body)
    }

    open func style(heading str: NSMutableAttributedString, level: Int) {
        let font = fonts.attributeFor(headingLevel: level) ?? fonts.heading1

        str.updateAttribute(.font) { (currentFont: UIFont) in
            var newFont = font

            if (currentFont.isMonospace) {
                newFont = newFont.monospace
            }
            
            if (currentFont.isItalic) {
                newFont = newFont.italic
            }

            if (currentFont.isBold) {
                newFont = newFont.bold
            }

            return newFont
        }

        let color = colors.attributeFor(headingLevel: level) ?? colors.heading1
        let paragraphStyle = paragraphStyles.attributeFor(headingLevel: level) ?? paragraphStyles.heading1

        str.addAttributes([
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle])
    }

    open func style(thematicBreak str: NSMutableAttributedString) {
        str.addAttribute(.thematicBreak, value: ThematicBreakAttribute(thickness: 1, color: colors.thematicBreak))
    }

    open func style(text str: NSMutableAttributedString) {
        str.setAttributes([
            .font: fonts.body,
            .foregroundColor: colors.body])
    }

    open func style(softBreak str: NSMutableAttributedString) {

    }

    open func style(lineBreak str: NSMutableAttributedString) {

    }

    open func style(code str: NSMutableAttributedString) {
        str.setAttributes([
            .font: fonts.code,
            .foregroundColor: colors.code])
    }

    open func style(htmlInline str: NSMutableAttributedString) {
        str.setAttributes([
            .font: fonts.code,
            .foregroundColor: colors.code])
    }

    open func style(customInline str: NSMutableAttributedString) {
        // Not supported.
    }

    open func style(emphasis str: NSMutableAttributedString) {
        str.updateAttribute(.font) { (font: UIFont) in
            font.italic
        }
    }

    open func style(strong str: NSMutableAttributedString) {
        str.updateAttribute(.font) { (font: UIFont) in
            font.bold
        }
    }

    open func style(link str: NSMutableAttributedString, title: String?, url: String?) {
        guard let url = url else { return }
        str.addAttribute(.link, value: url)
    }

    open func style(image str: NSMutableAttributedString, title: String?, url: String?) {
        guard let url = url else { return }
        str.addAttribute(.link, value: url)
    }
}

// MARK: - Helper Extensions

private extension UIFont {

    var widthOfLargestDigit: CGFloat {
        (0...9)
            .map { NSAttributedString(string: "\($0)", attributes: [.font: self]).size().width }
            .max()!
    }
}

#endif
