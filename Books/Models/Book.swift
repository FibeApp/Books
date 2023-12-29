import SwiftUI
import SwiftData

@Model
class Book {
    var title: String
    var author: String
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    var sinopsis: String
    var rating: Int?
    var status: Status.RawValue
    var recommendedBy: String = ""

    init(
        title: String,
        author: String,
        dateAdded: Date = Date.now,
        dateStarted: Date = Date.distantPast,
        dateCompleted: Date = Date.distantPast,
        sinopsis: String = "",
        rating: Int? = nil,
        status: Status = .onShelf,
        recommendedBy: String = ""
    ) {
        self.title = title
        self.author = author
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.sinopsis = sinopsis
        self.rating = rating
        self.status = status.rawValue
        self.recommendedBy = recommendedBy
    }

    var icon: Image {
        Image(systemName: statusFromRaw.icon)
    }

    var statusFromRaw: Status {
        Status(rawValue: status) ?? .onShelf
    }
}

enum Status: Int, Codable, Identifiable, CaseIterable {
    case onShelf, inProgress, completed

    var id: Self { self }

    var title: String {
        switch self {
        case .onShelf: "On Shelf"
        case .inProgress: "In Progress"
        case .completed: "Completed"
        }
    }

    var icon: String {
        switch self {
        case .onShelf: "checkmark.diamond.fill"
        case .inProgress: "book.fill"
        case .completed: "books.vertical.fill"
        }
    }
}
