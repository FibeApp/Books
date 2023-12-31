import SwiftUI
import PhotosUI

final class EditBookViewModel: ObservableObject {
    let book: Book
    @Published var status: Status
    @Published var rating: Int?
    @Published var title = "title"
    @Published var author = ""
    @Published var sinopsis = ""
    @Published var dateAdded = Date.distantPast
    @Published var dateStarted = Date.distantPast
    @Published var dateCompleted = Date.distantPast
    @Published var recommendedBy = ""
    @Published var selectedBookCover: PhotosPickerItem?
    @Published var selectedBookCoverData: Data?

    init(book: Book) {
        self.book = book
        status = book.statusFromRaw
        rating = book.rating
        title = book.title
        author = book.author
        sinopsis = book.sinopsis
        dateAdded = book.dateAdded
        dateStarted = book.dateStarted
        dateCompleted = book.dateCompleted
        recommendedBy = book.recommendedBy
        selectedBookCoverData = book.bookCover
    }

    func update() {
        book.status = status.rawValue
        book.rating = rating
        book.title = title
        book.author = author
        book.sinopsis = sinopsis
        book.dateAdded = dateAdded
        book.dateStarted = dateStarted
        book.dateCompleted = dateCompleted
        book.recommendedBy = recommendedBy
        book.bookCover = selectedBookCoverData
    }

    var changed: Bool {
        status != book.statusFromRaw
        || rating != book.rating
        || title != book.title
        || author != book.author
        || sinopsis != book.sinopsis
        || dateAdded != book.dateAdded
        || dateStarted != book.dateStarted
        || dateCompleted != book.dateCompleted
        || recommendedBy != book.recommendedBy
        || selectedBookCoverData != book.bookCover
    }

    func updateDates(oldValue: Status, newValue: Status) {
        if newValue == .onShelf {
            dateStarted = Date.distantPast
            dateCompleted = Date.distantPast
        } else if newValue == .inProgress && oldValue == .completed {
            // from completed to inProgress
            dateCompleted = Date.distantPast
        } else if newValue == .inProgress && oldValue == .onShelf {
            // Book has been started
            dateStarted = Date.now
        } else if newValue == .completed && oldValue == .onShelf {
            // Forgot to start book
            dateCompleted = Date.now
            dateStarted = dateAdded
        } else {
            // completed
            dateCompleted = Date.now
        }
    }
}
