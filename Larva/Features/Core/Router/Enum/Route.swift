//
//  Route.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 17/06/25.
//

import SwiftUI

enum Route: Hashable {
    case home
    case camera
    case preview(image: UIImage)
    case imageProcessor(image: UIImage)
    case result(result: FinalResult)
}
