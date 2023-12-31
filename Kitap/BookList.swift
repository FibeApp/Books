import SwiftUI
import SwiftData

struct BookList: View {
    @Environment(\.modelContext) private var context
    @Query private var books: [Book]
    init(sortOrder: SortOrder, filter: String) {
        let sortDescriptors: [SortDescriptor<Book>] = switch sortOrder {
        case .status: [SortDescriptor(\Book.status), SortDescriptor(\Book.title)]
        case .title: [SortDescriptor(\Book.title)]
        case .author: [SortDescriptor(\Book.author)]
        }
        let predicat = #Predicate<Book> {
            $0.title.localizedStandardContains(filter) ||
            $0.author.localizedStandardContains(filter) ||
            filter.isEmpty
        }
        _books = Query(filter: predicat, sort: sortDescriptors)
    }
    var body: some View {
        Group {
            if books.isEmpty {
                ContentUnavailableView("Enter your first book.", systemImage: "book.fill")
            } else {
                List {
                    ForEach(books) { book in
                        NavigationLink(value: book) {
                            ExtractedView(book: book)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let book = books[index]
                            context.delete(book)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationDestination(for: Book.self) { book in
            EditBookView(viewModel: EditBookViewModel(book: book))
        }

    }
}

struct ExtractedView: View {
    let book: Book
    var body: some View {
        HStack(spacing: 10) {
            book.icon
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.title2)
                Text(book.author)
                    .foregroundStyle(.secondary)
                if let genres = book.genres {
                    ViewThatFits {
                        ScrollView(.horizontal, showsIndicators: false) {
                            GenreStackView(genres: genres)
                        }
                    }
                }
                if let rating = book.rating {
                    HStack {
                        ForEach(0..<rating, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .imageScale(.small)
                                .foregroundStyle(.yellow)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    preview.addExamples(Book.samples)
    return NavigationStack {
        BookList(sortOrder: .status, filter: "")
    }
        .modelContainer(preview.container)
}
