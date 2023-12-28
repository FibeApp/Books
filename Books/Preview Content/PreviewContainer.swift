import Foundation
import SwiftData

struct Preview {
    let container: ModelContainer
    init(_ models: any PersistentModel.Type...) {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema(models)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container")
        }
    }

    func addExamples(_ examples: [any PersistentModel]) {
        Task { @MainActor in
            examples.forEach {
                container.mainContext.insert($0)
            }
        }
    }
}
