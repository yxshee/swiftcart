//
//  CartItem.swift
//  Ecommerce
//

import Foundation

struct CartItem: Identifiable, Hashable {
    let id: UUID
    let product: Product
    var quantity: Int
    var selectedColor: String?
    var selectedSize: String?
    
    init(product: Product, quantity: Int = 1, selectedColor: String? = nil, selectedSize: String? = nil) {
        self.id = UUID()
        self.product = product
        self.quantity = quantity
        self.selectedColor = selectedColor ?? product.colors?.first
        self.selectedSize = selectedSize ?? product.sizes?.first
    }
    
    var totalPrice: Double {
        return product.price * Double(quantity)
    }
    
    var formattedTotalPrice: String {
        return String(format: "$%.2f", totalPrice)
    }
}
