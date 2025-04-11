import SwiftUI

struct Theme {
    static let primaryColor = Color.orange
    static let backgroundColor = Color(.systemBackground)
    static let secondaryBackgroundColor = Color(.secondarySystemBackground)
    
    struct Padding {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }
    
    struct ImageSize {
        static let thumbnail: CGFloat = 80
        static let medium: CGFloat = 120
        static let large: CGFloat = 200
    }
}

// MARK: - View Modifiers
extension View {
    func recipeCellStyle() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding(Theme.Padding.medium)
            .background(Theme.secondaryBackgroundColor, in: RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
    }
    
    func recipeHeaderStyle() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(Theme.backgroundColor)
    }
} 