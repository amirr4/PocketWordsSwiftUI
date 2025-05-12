//
//  XPTracker.swift
//  PocketWordsSwiftUI
//
//  Created by Amir on 5/12/25.
//

import Foundation
import SwiftData

@Model
class XPTracker {
    var xp: Int = 0

    init(xp: Int = 0) {
        self.xp = xp
    }
}
