//
//  OrderConfirmationView.swift
//  Ecommerce
//

import SwiftUI

struct OrderConfirmationView: View {
    let orderId: String
    @Environment(\.dismiss) private var dismiss
    
    @State private var showConfetti = false
    @State private var animateCheckmark = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Spacer(minLength: 40)
                
                // Success Animation
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.green.opacity(0.3), .clear],
                                center: .center,
                                startRadius: 40,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                        .scaleEffect(animateCheckmark ? 1 : 0.5)
                        .opacity(animateCheckmark ? 1 : 0)
                    
                    // Inner circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.green, .green.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .scaleEffect(animateCheckmark ? 1 : 0)
                    
                    // Checkmark
                    Image(systemName: "checkmark")
                        .font(.system(size: 45, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(animateCheckmark ? 1 : 0)
                }
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: animateCheckmark)
                
                // Success Message
                VStack(spacing: 12) {
                    Text("Order Placed!")
                        .font(.title.weight(.bold))
                    
                    Text("Thank you for your purchase")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Order ID
                VStack(spacing: 8) {
                    Text("Order Number")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(orderId)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.gradientStart)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.gradientStart.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                // Order Details Card
                VStack(spacing: 16) {
                    DetailRow(
                        icon: "envelope.fill",
                        title: "Confirmation Email",
                        subtitle: "A confirmation has been sent to your email"
                    )
                    
                    Divider()
                    
                    DetailRow(
                        icon: "shippingbox.fill",
                        title: "Shipping Updates",
                        subtitle: "You'll receive tracking information soon"
                    )
                    
                    Divider()
                    
                    DetailRow(
                        icon: "clock.fill",
                        title: "Estimated Delivery",
                        subtitle: estimatedDelivery
                    )
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
                
                // Actions
                VStack(spacing: 12) {
                    NavigationLink(destination: ProductListView()) {
                        HStack {
                            Image(systemName: "bag")
                            Text("Continue Shopping")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.gradientStart, .gradientEnd],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Button(action: trackOrder) {
                        HStack {
                            Image(systemName: "location")
                            Text("Track Order")
                        }
                        .font(.headline)
                        .foregroundColor(.gradientStart)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.gradientStart.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animateCheckmark = true
            }
        }
    }
    
    private var estimatedDelivery: String {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: 3, to: Date())!
        let endDate = calendar.date(byAdding: .day, value: 5, to: Date())!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
    
    private func trackOrder() {
        // In a real app, navigate to order tracking
    }
}

// MARK: - Detail Row
struct DetailRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.gradientStart)
                .frame(width: 44, height: 44)
                .background(Color.gradientStart.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.medium))
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        OrderConfirmationView(orderId: "ORD-123456")
    }
}
