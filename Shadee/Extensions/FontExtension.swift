//
//  FontExtension.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 18/06/25.
//

import SwiftUI

extension Font {
    enum NewYorkFont: String {
        case regular = "NewYorkSmall-Regular"
        case semibold = "NewYorkSmall-Semibold"

        init(_ fontWeight: Font.Weight) {
            switch fontWeight {
            case .regular:
                self = .regular
            case .semibold:
                self = .semibold
            default:
                self = .regular
            }
        }
    }

    static func newYork(_ fontWeight: Weight = .regular, size: CGFloat = 26) -> Font {
        return .custom(NewYorkFont(fontWeight).rawValue, size: size)
    }
}
