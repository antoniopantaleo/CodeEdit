//
//  QuickOpenTextFormatterTests.swift
//  CodeEditTests
//
//  Created by Antonio Pantaleo on 20/03/24.
//

import XCTest
@testable import CodeEdit

final class QuickOpenTextFormatterTests: XCTestCase {

    typealias HighlightResult = (indexes: [Int], characters: [String])

    func test_highlightText_matchCharacters() {
        // Given
        let sut = makeSUT(word: "hello, world!", query: "hlld")
        // Then
        XCTAssertEqual(highlightedCharacters(in: sut).indexes, [0, 2, 3, 11])
        XCTAssertEqual(highlightedCharacters(in: sut).characters, ["h", "l", "l", "d"])
    }

    func test_highlightText_matchCharactersCaseInsensitive() {
        // Given
        let sut = makeSUT(word: "HELLO, WORLD!", query: "hlld")
        // Then
        XCTAssertEqual(highlightedCharacters(in: sut).indexes, [0, 2, 3, 11])
        XCTAssertEqual(highlightedCharacters(in: sut).characters, ["H", "L", "L", "D"])
    }

    func test_highlightText_matchSymbols() {
        // Given
        let sut = makeSUT(word: "$tring w!th symbøls", query: "$g!")
        // Then
        XCTAssertEqual(highlightedCharacters(in: sut).indexes, [0, 5, 8])
        XCTAssertEqual(highlightedCharacters(in: sut).characters, ["$", "g", "!"])
    }

    func test_highlightText_matchCharactersWithAccent() {
        // Given
        let sut = makeSUT(word: "àccènt", query: "aet")
        // Then
        XCTAssertEqual(highlightedCharacters(in: sut).indexes, [0, 3, 5])
        XCTAssertEqual(highlightedCharacters(in: sut).characters, ["à", "è", "t"])
    }

    func test_highlightText_ignoreWhitespaces() {
        // Given
        let sut = makeSUT(word: "a space", query: " ")
        // Then
        XCTAssertEqual(highlightedCharacters(in: sut).indexes, [])
        XCTAssertEqual(highlightedCharacters(in: sut).characters, [])
    }

    func test_highlightText_doesNotHighlightAfterUnmatchingCharacter() {
        // Given
        let sut = makeSUT(word: "Alligator", query: "ldo")
        // Then
        XCTAssertEqual(highlightedCharacters(in: sut).indexes, [])
        XCTAssertEqual(highlightedCharacters(in: sut).characters, [])
    }

    // MARK: - Helpers

    private func makeSUT(word: String, query: String) -> NSAttributedString {
        QuickOpenTextFormatter.highlightText(word, fromSearchQuery: query)
    }

    private func highlightedCharacters(in attributedString: NSAttributedString) -> HighlightResult {
        attributedString.string.enumerated()
            .reduce(into: ([Int](), [String]())) { partialResult, item in
                guard !attributedString
                    .attributes(at: item.offset, effectiveRange: nil)
                    .filter({ key, value in
                        key == .font && (value as? NSObject) == NSFont.boldSystemFont(ofSize: 13)
                    }).isEmpty
                else { return }
                partialResult.indexes.append(item.offset)
                partialResult.characters.append(String(item.element))
            }
    }
}
