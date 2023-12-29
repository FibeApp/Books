import SwiftUI
import PhotosUI
struct EditBookView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: EditBookViewModel
    @State private var show = false
    var body: some View {
        VStack(alignment: .leading) {
            statusView
            datesView
            textsView
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $show) {
            GenresView(book: viewModel.book)
        }
        .toolbar {
            if viewModel.changed {
                Button("Update") {
                    viewModel.update()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .task(id: viewModel.selectedBookCover) {
            if let data = try? await viewModel.selectedBookCover?.loadTransferable(type: Data.self) {
                viewModel.selectedBookCoverData = data
            }
        }
    }
    var textsView: some View {
        GroupBox {
            LabeledContent {
                RatingView(maxRating: 5, currentRating: $viewModel.rating)
                    .frame(height: 20)
            } label: {
                Text("Rating")
            }
            HStack {
                PhotosPicker(
                    selection: $viewModel.selectedBookCover,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Group {
                            if let data = viewModel.selectedBookCoverData,
                            let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                        .frame(width: 75, height: 100)
                        .clipShape(.rect(cornerRadius: 10))
                        .overlay(alignment: .topTrailing) {
                            if viewModel.selectedBookCoverData != nil {
                                Button {
                                    viewModel.selectedBookCover = nil
                                    viewModel.selectedBookCoverData = nil
                                } label: {
                                    Image(systemName: "x.circle.fill")
                                        .foregroundStyle(.red)
                                        .offset(x: 10.0, y: -10)
                                }
                            }
                        }
                    }
                VStack {
                    LabeledContent {
                        TextField("", text: $viewModel.title)
                    } label: {
                        Text("Title").foregroundStyle(.secondary)
                    }
                    LabeledContent {
                        TextField("", text: $viewModel.author)
                    } label: {
                        Text("Author").foregroundStyle(.secondary)
                    }
                    LabeledContent {
                        TextField("", text: $viewModel.recommendedBy)
                    } label: {
                        Text("Recommended By").foregroundStyle(.secondary)
                    }
                }
            }
            Divider()
            Text("Sinopsis")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextEditor(text: $viewModel.sinopsis)
                .padding(5)
            if let genres = viewModel.book.genres {
                ViewThatFits {
                    ScrollView(.horizontal, showsIndicators: false) {
                        GenreStackView(genres: genres)
                    }
                }
            }
            HStack {
                Button("Gengres", systemImage: "bookmark.fill") {
                    show.toggle()
                }
                NavigationLink {
                    QuotesListView(viewModel: QuotesListViewModel(book: viewModel.book))
                } label: {
                    let count = viewModel.book.quotes?.count ?? 0
                    Label("\(count) Quotes", systemImage: "quote.opening")
                }
            }
            .buttonStyle(.bordered)
            .tint(.primary)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
        }
    }

    var datesView: some View {
        GroupBox {
            LabeledContent {
                switch viewModel.status {
                case .onShelf:
                    DatePicker(
                        "",
                        selection: $viewModel.dateAdded,
                        displayedComponents: .date
                    )
                case .completed, .inProgress:
                    DatePicker(
                        "",
                        selection: $viewModel.dateAdded,
                        in: ...viewModel.dateStarted,
                        displayedComponents: .date
                    )
                }
            } label: {
                Text("Date Added")
            }

            if viewModel.status == .inProgress || viewModel.status == .completed {
                LabeledContent {
                    DatePicker(
                        "",
                        selection: $viewModel.dateStarted,
                        in: viewModel.dateAdded...,
                        displayedComponents: .date
                    )
                } label: {
                    Text("Date Started")
                }
            }

            if viewModel.status == .completed {
                LabeledContent {
                    DatePicker(
                        "",
                        selection: $viewModel.dateCompleted,
                        in: viewModel.dateStarted...,
                        displayedComponents: .date
                    )
                } label: {
                    Text("Date Completed")
                }
            }
        }
        .foregroundStyle(.secondary)
        .onChange(of: viewModel.status, viewModel.updateDates)
    }
    var statusView: some View {
        GroupBox {
            LabeledContent {
                Picker("Status", selection: $viewModel.status) {
                    ForEach(Status.allCases) { status in
                        Text(status.title).tag(status)
                    }
                }
                .buttonStyle(.bordered)
                .tint(.primary)
            } label: {
                Text("Status")
            }
        }
    }
}

#Preview("English") {
    let preview = Preview(Book.self)
    return NavigationStack {
        EditBookView(viewModel: EditBookViewModel(book: Book.samples[4]))
            .modelContainer(preview.container)
    }
}

#Preview("Russian") {
    let preview = Preview(Book.self)
    return NavigationStack {
        EditBookView(viewModel: EditBookViewModel(book: Book.samples[4]))
            .modelContainer(preview.container)
            .environment(\.locale, Locale(identifier: "RU"))
    }
}
