//
//  ProfileView.swift
//  Ecommerce
//

import SwiftUI

struct ProfileView: View {
    @State private var user = UserProfile.sample
    @State private var showEditProfile = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                profileHeader
                
                // Menu Sections
                VStack(spacing: 16) {
                    // Orders Section
                    menuSection(title: "My Orders") {
                        MenuItem(icon: "bag", title: "All Orders", badge: "3")
                        MenuItem(icon: "shippingbox", title: "Track Order")
                        MenuItem(icon: "arrow.uturn.backward", title: "Returns & Refunds")
                    }
                    
                    // Account Section
                    menuSection(title: "Account Settings") {
                        MenuItem(icon: "location", title: "Addresses")
                        MenuItem(icon: "creditcard", title: "Payment Methods")
                        MenuItem(icon: "bell", title: "Notifications")
                        MenuItem(icon: "lock", title: "Privacy & Security")
                    }
                    
                    // Support Section
                    menuSection(title: "Support") {
                        MenuItem(icon: "questionmark.circle", title: "Help Center")
                        MenuItem(icon: "message", title: "Contact Us")
                        MenuItem(icon: "doc.text", title: "Terms & Conditions")
                        MenuItem(icon: "shield", title: "Privacy Policy")
                    }
                    
                    // Logout Button
                    Button(action: logout) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log Out")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                }
                
                // App Version
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
            .padding(.vertical)
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showEditProfile = true }) {
                    Image(systemName: "pencil")
                }
            }
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.gradientStart, .gradientEnd],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Text(user.initials)
                    .font(.title.weight(.bold))
                    .foregroundColor(.white)
            }
            
            // Name & Email
            VStack(spacing: 4) {
                Text(user.name)
                    .font(.title2.weight(.bold))
                
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Stats
            HStack(spacing: 0) {
                StatItem(value: "12", label: "Orders")
                Divider().frame(height: 40)
                StatItem(value: "3", label: "Wishlist")
                Divider().frame(height: 40)
                StatItem(value: "5", label: "Reviews")
            }
            .padding()
            .background(Color.appSecondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
        }
    }
    
    // MARK: - Menu Section
    private func menuSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                content()
            }
            .background(Color.appSecondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
    }
    
    private func logout() {
        // Handle logout
    }
}

// MARK: - Stat Item
struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.weight(.bold))
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Menu Item
struct MenuItem: View {
    let icon: String
    let title: String
    var badge: String? = nil
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.gradientStart)
                    .frame(width: 24)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let badge = badge {
                    Text(badge)
                        .font(.caption.weight(.medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gradientStart)
                        .clipShape(Capsule())
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

// MARK: - User Profile Model
struct UserProfile {
    let name: String
    let email: String
    let phone: String
    
    var initials: String {
        name.split(separator: " ")
            .compactMap { $0.first }
            .map { String($0) }
            .joined()
            .prefix(2)
            .uppercased()
    }
    
    static let sample = UserProfile(
        name: "Yash Dogra",
        email: "yxshdogra@gmail.com",
        phone: "+91 7876205914"
    )
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
