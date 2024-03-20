//
//  QuickOpenItem.swift
//  CodeEditModules/QuickOpen
//
//  Created by Pavel Kasila on 20.03.22.
//

import SwiftUI

struct QuickOpenItem: View {
    private let baseDirectory: URL
    private let fileURL: URL
    @Binding private var searchQuery: String

    init(
        baseDirectory: URL,
        fileURL: URL,
        searchQuery: Binding<String>
    ) {
        self.baseDirectory = baseDirectory
        self.fileURL = fileURL
        self._searchQuery = searchQuery
    }

    var relativePathComponents: ArraySlice<String> {
        return fileURL.pathComponents.dropFirst(baseDirectory.pathComponents.count).dropLast()
    }

    private var highlightedFileName: AttributedString {
        let attributedText = QuickOpenTextFormatter.highlightText(
            fileURL.lastPathComponent,
            fromSearchQuery: searchQuery
        )
        return AttributedString(attributedText)
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(nsImage: NSWorkspace.shared.icon(forFile: fileURL.path))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
            VStack(alignment: .leading, spacing: 0) {
                Text(highlightedFileName)
                    .lineLimit(1)
                Text(relativePathComponents.joined(separator: " ▸ "))
                    .font(.system(size: 10.5))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
    }
}
