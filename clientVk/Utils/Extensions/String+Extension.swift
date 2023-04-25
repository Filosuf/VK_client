//
//  String+Extension.swift
//  ClientVk
//
//  Created by Filosuf on 15.04.2023.
//

import Foundation

extension String {
    var localized: String { NSLocalizedString(self, comment: "") }
}

extension String {
    func shortPhoneNumber() -> String? {
        let onlyDigits = self.onlyDigits()
        guard onlyDigits.count >= 10 else { return nil }
        return onlyDigits.substring(fromIndex: onlyDigits.count - 10)
    }

    func onlyDigits() -> String {
        let filteredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filteredUnicodeScalars))
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
