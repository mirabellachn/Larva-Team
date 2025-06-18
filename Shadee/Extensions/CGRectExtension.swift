//
//  CGRectExtension.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 16/06/25.
//

import SwiftUI

extension CGRect {
    func flipY() -> CGRect {
        return CGRect(origin: CGPoint(x: origin.x, y: 1 - origin.y - size.height), size: size)
    }
}
