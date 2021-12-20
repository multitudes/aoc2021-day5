//
//  String+Ext.swift
//  day5
//
//  Created by Laurent B on 20/12/2021.
//

import Foundation

/// as a little help to extrapolate the input data
extension String {
    func getTrimmedCapturedGroupsFrom(regexPattern: String)-> [String]? {
        let text = self
        let regex = try? NSRegularExpression(pattern: regexPattern)
        
        let match = regex?.firstMatch(in: text, range: NSRange(text.startIndex..., in: text))
        
        if let match = match {
            return (0..<match.numberOfRanges).compactMap {
                if let range = Range(match.range(at: $0), in: text) {
                    return $0 > 0 ? String(text[range]).trimmingCharacters(in: .whitespaces) : nil
                }
                return nil
            }
        }
        return nil
    }
}
