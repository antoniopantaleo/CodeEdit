//
//  QuickOpenTextFormatter.swift
//  CodeEdit
//
//  Created by Antonio Pantaleo on 20/03/24.
//

import AppKit

enum QuickOpenTextFormatter {

    static func highlightText(_ text: String, fromSearchQuery query: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let normalizedText = normalized(text)
        var currentRange = normalizedText.startIndex..<normalizedText.endIndex
        for char in normalized(query.trimmingCharacters(in: .whitespacesAndNewlines)) {
            guard let range = normalizedText.range(
                of: String(char),
                options: [.caseInsensitive],
                range: currentRange
            ) else { return NSMutableAttributedString(string: text) }

            let boldAttributes: [NSAttributedString.Key: Any] = [ .font: NSFont.boldSystemFont(ofSize: 13) ]
            attributedString.addAttributes(boldAttributes, range: NSRange(range, in: normalizedText))
            currentRange = range.upperBound..<normalizedText.endIndex
        }
        return attributedString
    }

    private static func normalized(_ string: String) -> String {
        string
            .normalise()
            .reduce("") { $0 + $1.normalisedContent }
    }
}
