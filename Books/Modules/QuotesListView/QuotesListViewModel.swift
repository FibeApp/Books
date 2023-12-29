import Foundation

class QuotesListViewModel: ObservableObject {
    let book: Book

    @Published var text = ""
    @Published var page = ""
    @Published var selectedQuote: Quote?

    var sortedQuotes: [Quote] {
        book.quotes?.sorted(using: KeyPathComparator(\Quote.creationDate)) ?? []
    }

    var isEditing: Bool {
        selectedQuote != nil
    }
    
    init(book: Book) {
        self.book = book
    }

    func cancel() {
        page = ""
        text = ""
        selectedQuote = nil
    }

    var buttonTitle: String {
        isEditing ? "Update" : "Created"
    }

    func update() {
        if isEditing {
            selectedQuote?.text = text
            selectedQuote?.page = page.isEmpty ? nil : page
            selectedQuote = nil
        } else {
            let quote = page.isEmpty ? Quote(text: text) : Quote(text: text, page: page)
            book.quotes?.append(quote)
        }
        page = ""
        text = ""
    }

    func setQuote(_ quote: Quote) {
        selectedQuote = quote
        text = quote.text
        page = quote.page ?? ""
    }
}
