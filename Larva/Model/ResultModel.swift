//
//  Item.swift
//  Larva
//
//  Created by Ageng Tawang Aryonindito on 12/06/25.
//

import Foundation
import SwiftData

@Model
final class FinalResult {
    var skinTone: String
    var underTone: String
    var shades: [Shade]
    init(skinTone: String, underTone: String, shades: [Shade]) {
        self.skinTone = skinTone
        self.underTone = underTone
        self.shades = shades
    }
}

@Model
class Shade {
    var shade: String
    init(shade: String) {
        self.shade = shade
    }
}
