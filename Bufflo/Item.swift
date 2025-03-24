//
//  Item.swift
//  Bufflo
//
//  Created by Jessica Lynn on 24/03/25.
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
