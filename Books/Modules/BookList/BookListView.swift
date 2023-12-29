import SwiftUI
import SwiftData

enum SortOrder: LocalizedStringResource, Identifiable, CaseIterable {
    case status, title, author
    var id: Self { self }
}
struct BookListView: View {
    @State private var createNewBook = false
    @State private var sortOrder = SortOrder.status
    @State private var filter = ""
    var body: some View {
        NavigationStack {
            Picker("", selection: $sortOrder) {
                ForEach(SortOrder.allCases) {
                    Text("Sort by \($0.rawValue)").tag($0)
                }
            }.buttonStyle(.bordered)
            BookList(sortOrder: sortOrder, filter: filter)
                .searchable(text: $filter, prompt: Text("Filter on title or author"))
                .navigationTitle("My Books")
                .toolbar  {
                    Button {
                        createNewBook.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                .sheet(isPresented: $createNewBook) {
                    NewBookView()
                        .presentationDetents([.medium])
                }
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
    let books = Book.samples
    let genres = Genre.samples
    preview.addExamples(books)
    preview.addExamples(genres)
    return BookListView()
        .modelContainer(preview.container)
}
