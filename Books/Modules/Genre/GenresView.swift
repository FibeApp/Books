import SwiftUI
import SwiftData

struct GenresView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Bindable var book: Book
    @Query(sort: \Genre.name) var genres: [Genre]
    @State private var newGenre = false
    var body: some View {
        NavigationStack {
            Group {
                if genres.isEmpty {
                    contentUnavailable
                } else {
                    content
                }
            }
            .navigationTitle(book.title)
            .sheet(isPresented: $newGenre) {
                NewGenreView()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
    var contentUnavailable: some View {
        ContentUnavailableView {
            Image(systemName: "bookmark.fill")
                .font(.largeTitle)
        } description: {
            Text("You need to create some genres first.")
        } actions: {
            Button("Create Genre") {
                newGenre.toggle()
            }
            .buttonStyle(.borderedProminent)
        }
    }
    var content: some View {
        List {
            ForEach(genres) { genre in
                HStack {
                    if let bookGenres = book.genres {
                        Button {
                            addRemove(genre, bookGenres: bookGenres)
                        } label: {
                            Image(systemName: bookGenres.contains(genre) ? "circle.fill" : "circle")
                        }
                        .foregroundStyle(genre.hexColor)
                    }
                    Text(genre.name)
                }
            }
            .onDelete(perform: deleteGenre)
            createNewGenre
        }
        .listStyle(.plain)
    }

    var createNewGenre: some View {
        LabeledContent {
            Button {
                newGenre.toggle()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .imageScale(.large)
            }
            .buttonStyle(.borderedProminent)
        } label: {
            Text("Create new Genre")
                .font(.caption).foregroundStyle(.secondary)
        }
    }

    func deleteGenre(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            if let bookGenres = book.genres,
               bookGenres.contains(genres[index]),
               let bookGenreIndex = bookGenres.firstIndex(where: {
                   $0.id == genres[index].id
               })
            {
                book.genres?.remove(at: bookGenreIndex)
            }
            context.delete(genres[index])
        }
    }

    func addRemove(_ genre: Genre, bookGenres: [Genre]) {
        if bookGenres.isEmpty {
            book.genres?.append(genre)
        } else {
            if bookGenres.contains(genre),
               let index = bookGenres.firstIndex(where: {$0.id == genre.id}) {
                book.genres?.remove(at: index)
            } else {
                book.genres?.append(genre)
            }
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    let books = Book.samples
    let genres = Genre.samples
    preview.addExamples(genres)
    preview.addExamples(books)
    books[1].genres?.append(genres[0])
    return GenresView(book: books[1])
        .modelContainer(preview.container)
}
