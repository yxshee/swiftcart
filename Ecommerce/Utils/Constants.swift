//
//  Constants.swift
//  Ecommerce
//

import SwiftUI

struct AppConstants {
    // MARK: - API
    struct API {
        static let baseURL = "https://api.example.com/v1"
        static let timeout: TimeInterval = 30
    }
    
    // MARK: - UI
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let largeCornerRadius: CGFloat = 20
        static let spacing: CGFloat = 16
        static let smallSpacing: CGFloat = 8
        static let padding: CGFloat = 16
        static let iconSize: CGFloat = 24
    }
    
    // MARK: - Animation
    struct Animation {
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let spring = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.7)
    }
}

// MARK: - Color Extensions
extension Color {
    static let appPrimary = Color("AccentColor")
    static let appBackground = Color(uiColor: .systemBackground)
    static let appSecondaryBackground = Color(uiColor: .secondarySystemBackground)
    static let appText = Color(uiColor: .label)
    static let appSecondaryText = Color(uiColor: .secondaryLabel)
    static let appSuccess = Color.green
    static let appError = Color.red
    static let appWarning = Color.orange
    
    // Gradient colors
    static let gradientStart = Color(red: 0.4, green: 0.2, blue: 0.9)
    static let gradientEnd = Color(red: 0.8, green: 0.3, blue: 0.7)
}

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        self
            .background(Color.appSecondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadius))
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [.gradientStart, .gradientEnd],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadius))
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.appPrimary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.appPrimary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.UI.cornerRadius))
    }
}

// MARK: - Double Extensions
extension Double {
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: self)) ?? "$\(self)"
    }
}

// MARK: - String Extensions
extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPhone: Bool {
        let phoneRegex = "^[0-9+]{10,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self.replacingOccurrences(of: " ", with: ""))
    }
}
