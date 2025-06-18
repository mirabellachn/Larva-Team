//
//  InnerHeightPreferenceKey.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 19/06/25.
//

import SwiftUI

struct InnerHeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
