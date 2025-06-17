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
    var scale: String
    var shades: [Shade]
    init(skinTone: String, underTone: String, scale: String, shades: [Shade]) {
        self.skinTone = skinTone
        self.underTone = underTone
        self.scale = scale
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
