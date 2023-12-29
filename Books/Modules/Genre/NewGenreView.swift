import SwiftUI
import SwiftData

struct NewGenreView: View {
    @State private var name = ""
    @State private var color = Color.red
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                TextField("name", text: $name)
                ColorPicker(
                    "Set the genre color",
                    selection: $color,
                    supportsOpacity: false
                )
                Button("Create") {
                    createGenre()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .disabled(name.isEmpty)
            }
            .navigationTitle("New Genre")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func createGenre() {
        if let hexColor = color.toHexString() {
            let newGenre = Genre(name: name, color: hexColor)
            context.insert(newGenre)
            dismiss()
        }
    }
}

#Preview {
    NewGenreView()
}
