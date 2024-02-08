//
//  NSObject.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 08.02.2024.
//

import Foundation

extension NSObject {
    func smSearch(text: String, action: Selector, afterDelay: Double = 0.5) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(action, with: text, afterDelay: afterDelay)
    }
}
