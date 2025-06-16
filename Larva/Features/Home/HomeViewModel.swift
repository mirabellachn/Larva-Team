import SwiftUI
import SwiftData

class HomeViewModel: ObservableObject {
    @Published private(set) var haveResults: Bool = false
}
