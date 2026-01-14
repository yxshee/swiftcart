//
//  CartView.swift
//  Ecommerce
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var showCheckout = false
    
    var body: some View {
        Group {
            if cartManager.isEmpty {
                emptyCartView
            } else {
                cartContentView
            }
        }
        .navigationTitle("My Cart")
        .navigationDestination(isPresented: $showCheckout) {
            CheckoutView()
        }
    }
    
    // MARK: - Empty Cart View
    private var emptyCartView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.gradientStart.opacity(0.2), .gradientEnd.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "cart")
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.gradientStart, .gradientEnd],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 8) {
                Text("Your Cart is Empty")
                    .font(.title2.weight(.bold))
                
                Text("Looks like you haven't added\nany items to your cart yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            NavigationLink(destination: ProductListView()) {
                HStack {
                    Image(systemName: "bag")
                    Text("Start Shopping")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [.gradientStart, .gradientEnd],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
            }
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Cart Content View
    private var cartContentView: some View {
        VStack(spacing: 0) {
            // Cart Items List
            List {
                ForEach(cartManager.items) { item in
                    CartItemRow(item: item)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                .onDelete(perform: cartManager.removeItem)
                
                // Free Shipping Banner
                if cartManager.subtotal < 100 {
                    freeShippingBanner
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
            }
            .listStyle(.plain)
            
            // Order Summary
            orderSummary
        }
    }
    
    // MARK: - Free Shipping Banner
    private var freeShippingBanner: some View {
        let remaining = 100 - cartManager.subtotal
        let progress = cartManager.subtotal / 100
        
        return VStack(spacing: 12) {
            HStack {
                Image(systemName: "shippingbox")
                    .foregroundColor(.gradientStart)
                
                Text("Add \(String(format: "$%.2f", remaining)) more for FREE shipping!")
                    .font(.subheadline.weight(.medium))
                
                Spacer()
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                    
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.gradientStart, .gradientEnd],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * min(progress, 1), height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Order Summary
    private var orderSummary: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                HStack {
                    Text("Subtotal")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(cartManager.formattedSubtotal)
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text("Shipping")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(cartManager.formattedShipping)
                        .fontWeight(.medium)
                        .foregroundColor(cartManager.shippingCost == 0 ? .green : .primary)
                }
                
                HStack {
                    Text("Estimated Tax")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(cartManager.formattedTax)
                        .fontWeight(.medium)
                }
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.headline)
                    Spacer()
                    Text(cartManager.formattedTotal)
                        .font(.title2.weight(.bold))
                        .foregroundColor(.gradientStart)
                }
            }
            
            Button(action: { showCheckout = true }) {
                HStack {
                    Text("Proceed to Checkout")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
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
        }
        .padding()
        .background(.ultraThinMaterial)
    }
}

#Preview {
    NavigationStack {
        CartView()
    }
    .environmentObject(CartManager())
    .environmentObject(ProductStore())
}
