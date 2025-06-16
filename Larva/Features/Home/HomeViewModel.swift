import SwiftUI
import SwiftData

class HomeViewModel: ObservableObject {
    @Published private(set) var haveResults: Bool = false
    private let context: ModelContext
    init(haveResults: Bool, context: ModelContext) {
        self.haveResults = haveResults
        self.context = context
    }
    func setResult() {
        haveResults.toggle()
    }
}
