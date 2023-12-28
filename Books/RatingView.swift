import SwiftUI

struct RatingView: View {
    var maxRating: Int
    @Binding var currentRating: Int?
    var width: Int
    var color: UIColor
    var symbol: String

    public init(
        maxRating: Int,
        currentRating: Binding<Int?>,
        width: Int = 20,
        color: UIColor = .systemYellow,
        symbol: String = "star"
    ) {
        self.maxRating = maxRating
        self._currentRating = currentRating
        self.width = width
        self.color = color
        self.symbol = symbol
    }
    var body: some View {
        HStack {
            Image(systemName: symbol)
                .resizable()
                .scaledToFit()
                .symbolVariant(.slash)
                .opacity(currentRating == nil ? 0 : 1)
                .onTapGesture {
                    withAnimation {
                        currentRating = nil
                    }
                }
            ForEach(1...maxRating, id: \.self) { rating in
                Image(systemName: symbol)
                    .resizable()
                    .symbolVariant(correctImage(for: rating) ? .fill : .none)
                    .scaledToFit()
                    .onTapGesture {
                        withAnimation {
                            currentRating = rating
                        }
                    }
            }
        }
        .foregroundStyle(Color(color))
    }

    func correctImage(for rating: Int) -> Bool {
        if let currentRating, rating <= currentRating {
            return true
        } else {
            return false
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var currentRating: Int? = 3
        var body: some View {
            RatingView(maxRating: 5, currentRating: $currentRating)
        }
    }
    return PreviewWrapper()
}
