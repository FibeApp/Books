//
//  EditBookViewModel.swift
//  Books
//
//  Created by Vladimir Fibe on 27.12.2023.
//

import Foundation

final class EditBookViewModel: ObservableObject {
    let book: Book
    @Published var status = Status.onShelf
    @Published var rating: Int?
    @Published var title = "title"
    @Published var author = ""
    @Published var sinopsis = ""
    @Published var dateAdded = Date.distantPast
    @Published var dateStarted = Date.distantPast
    @Published var dateCompleted = Date.distantPast
    @Published var firstView = true

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
    }

    func updateDates(oldValue: Status, newValue: Status) {
        if !firstView {
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
            firstView = false
        }
    }
}
