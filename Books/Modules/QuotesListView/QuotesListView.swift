import SwiftUI

struct QuotesListView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: QuotesListViewModel
    var body: some View {
        GroupBox {
            HStack {
                LabeledContent("Page") {
                    TextField("page #", text: $viewModel.page)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                    Spacer()
                }
                if viewModel.isEditing {
                    Button("Cancel") {
                        viewModel.cancel()
                    }
                    .buttonStyle(.bordered)
                }
                Button(viewModel.buttonTitle) {
                    viewModel.update()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.text.isEmpty)
            }
            TextEditor(text: $viewModel.text)
                .border(Color.secondary)
                .frame(height: 100)
        }
        .padding(.horizontal)
        List {
            let sortedQuotes = viewModel.sortedQuotes
            ForEach(sortedQuotes) { quote in
                VStack(alignment: .leading) {
                    Text(quote.creationDate, format: .dateTime.month().day().year())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(quote.text)
                    HStack {
                        Spacer()
                        if let page = quote.page, !page.isEmpty {
                            Text("Page: \(page)")
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.setQuote(quote)
                }
            }
            .onDelete { indexSet in
                withAnimation {
                    indexSet.forEach { index in
                        let quote = sortedQuotes[index]
                        viewModel.book.quotes?.forEach {
                            if quote.id == $0.id {
                                modelContext.delete(quote)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Quotes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    let preview = Preview(Book.self)
//    let books = Book.samples
//    preview.addExamples(books)
//    return NavigationStack {
//        QuotesListView(viewModel: QuotesListViewModel(book: books[4]))
//            .modelContainer(preview.container)
//    }
//}
