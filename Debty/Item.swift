//
//  Item.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 22/04/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
