import SwiftUI
import SwiftData

@Model
class Genre {
    var name: String = ""
    var color: String = "FF0000"
    var books: [Book]?
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }

    var hexColor: Color {
        Color(hex: color) ?? .red
    }
}
