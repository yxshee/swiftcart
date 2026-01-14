//
//  Order.swift
//  Ecommerce
//

import Foundation

struct Order: Identifiable, Codable {
    let id: String
    let items: [OrderItem]
    let shippingAddress: ShippingAddress
    let paymentMethod: PaymentMethod
    let subtotal: Double
    let tax: Double
    let shippingCost: Double
    let total: Double
    let status: OrderStatus
    let createdAt: Date
    
    var formattedTotal: String {
        return String(format: "$%.2f", total)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
}

struct OrderItem: Identifiable, Codable, Hashable {
    let id: UUID
    let productId: Int
    let productName: String
    let price: Double
    let quantity: Int
    let selectedColor: String?
    let selectedSize: String?
    
    var totalPrice: Double {
        return price * Double(quantity)
    }
}

struct ShippingAddress: Codable, Hashable {
    var fullName: String
    var streetAddress: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
    var phoneNumber: String
    
    var formattedAddress: String {
        return "\(streetAddress)\n\(city), \(state) \(zipCode)\n\(country)"
    }
    
    static let empty = ShippingAddress(
        fullName: "",
        streetAddress: "",
        city: "",
        state: "",
        zipCode: "",
        country: "United States",
        phoneNumber: ""
    )
}

enum PaymentMethod: String, Codable, CaseIterable {
    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case applePay = "Apple Pay"
    case paypal = "PayPal"
    
    var icon: String {
        switch self {
        case .creditCard: return "creditcard.fill"
        case .debitCard: return "creditcard"
        case .applePay: return "apple.logo"
        case .paypal: return "p.circle.fill"
        }
    }
}

enum OrderStatus: String, Codable {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case shipped = "Shipped"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
    
    var color: String {
        switch self {
        case .pending: return "orange"
        case .confirmed: return "blue"
        case .shipped: return "purple"
        case .delivered: return "green"
        case .cancelled: return "red"
        }
    }
}
