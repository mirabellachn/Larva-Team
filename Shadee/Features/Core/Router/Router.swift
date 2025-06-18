//
//  Router.swift
//  Larva
//
//  Created by Abimanyu Damarjati on 17/06/25.
//

import SwiftUI

final class Router: ObservableObject {
    @Published var path = NavigationPath()

    func navigate(to route: Route) {
        path.append(route)
    }

    func navigateBack() {
        path.removeLast()
    }

    func popToView(count: Int) {
        path.removeLast(count)
    }

    func navigateToRoot() {
        path.removeLast(path.count)
    }
}

extension Router {
    func canNavigateBack() -> Bool {
        return path.count > 0
    }
}
