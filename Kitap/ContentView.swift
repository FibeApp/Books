import SwiftUI

struct ContentView: View {
    @State private var newBook = false
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
            .toolbar {
                Button {
                    newBook.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .sheet(isPresented: $newBook) {
            NewBookView()
        }
    }
}

#Preview {
    ContentView()
}
