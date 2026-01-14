//
//  CartManager.swift
//  Ecommerce
//
//  Manages shopping cart state across the app using @EnvironmentObject
//

import Foundation
import SwiftUI

class CartManager: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var isCheckingOut: Bool = false
    
    // MARK: - Computed Properties
    
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var subtotal: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    var tax: Double {
        subtotal * 0.08 // 8% tax
    }
    
    var shippingCost: Double {
        subtotal >= 100 ? 0 : 9.99 // Free shipping over $100
    }
    
    var total: Double {
        subtotal + tax + shippingCost
    }
    
    var formattedSubtotal: String {
        String(format: "$%.2f", subtotal)
    }
    
    var formattedTax: String {
        String(format: "$%.2f", tax)
    }
    
    var formattedShipping: String {
        shippingCost == 0 ? "FREE" : String(format: "$%.2f", shippingCost)
    }
    
    var formattedTotal: String {
        String(format: "$%.2f", total)
    }
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    // MARK: - Cart Operations
    
    func addToCart(_ product: Product, quantity: Int = 1, color: String? = nil, size: String? = nil) {
        // Check if product already exists in cart with same options
        if let index = items.firstIndex(where: { 
            $0.product.id == product.id && 
            $0.selectedColor == (color ?? product.colors?.first) &&
            $0.selectedSize == (size ?? product.sizes?.first)
        }) {
            // Update quantity
            items[index].quantity += quantity
        } else {
            // Add new item
            let cartItem = CartItem(
                product: product,
                quantity: quantity,
                selectedColor: color,
                selectedSize: size
            )
            items.append(cartItem)
        }
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func removeFromCart(_ item: CartItem) {
        withAnimation(.easeInOut(duration: 0.3)) {
            items.removeAll { $0.id == item.id }
        }
    }
    
    func removeItem(at offsets: IndexSet) {
        withAnimation(.easeInOut(duration: 0.3)) {
            items.remove(atOffsets: offsets)
        }
    }
    
    func updateQuantity(_ item: CartItem, quantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        
        if quantity <= 0 {
            removeFromCart(item)
        } else {
            items[index].quantity = quantity
        }
    }
    
    func incrementQuantity(_ item: CartItem) {
        updateQuantity(item, quantity: item.quantity + 1)
    }
    
    func decrementQuantity(_ item: CartItem) {
        updateQuantity(item, quantity: item.quantity - 1)
    }
    
    func clearCart() {
        withAnimation(.easeInOut(duration: 0.3)) {
            items.removeAll()
        }
    }
    
    func contains(_ product: Product) -> Bool {
        items.contains { $0.product.id == product.id }
    }
    
    func quantity(for product: Product) -> Int {
        items.filter { $0.product.id == product.id }.reduce(0) { $0 + $1.quantity }
    }
    
    // MARK: - Order Creation
    
    func createOrderItems() -> [OrderItem] {
        items.map { cartItem in
            OrderItem(
                id: UUID(),
                productId: cartItem.product.id,
                productName: cartItem.product.name,
                price: cartItem.product.price,
                quantity: cartItem.quantity,
                selectedColor: cartItem.selectedColor,
                selectedSize: cartItem.selectedSize
            )
        }
    }
}
