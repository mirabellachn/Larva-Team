//
//  Item.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 12/06/25.
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
