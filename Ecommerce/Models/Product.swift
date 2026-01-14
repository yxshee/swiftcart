//
//  Product.swift
//  Ecommerce
//

import Foundation

struct Product: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let description: String
    let price: Double
    let originalPrice: Double?
    let imageURL: String
    let category: String
    let rating: Double
    let reviewCount: Int
    let inStock: Bool
    let colors: [String]?
    let sizes: [String]?
    
    var discountPercentage: Int? {
        guard let original = originalPrice, original > price else { return nil }
        return Int(((original - price) / original) * 100)
    }
    
    var formattedPrice: String {
        return String(format: "$%.2f", price)
    }
    
    var formattedOriginalPrice: String? {
        guard let original = originalPrice else { return nil }
        return String(format: "$%.2f", original)
    }
}

// MARK: - Sample Data
extension Product {
    static let sampleProducts: [Product] = [
        Product(
            id: 1,
            name: "Premium Wireless Headphones",
            description: "Experience crystal-clear audio with our premium wireless headphones. Features active noise cancellation, 30-hour battery life, and ultra-comfortable ear cushions. Perfect for music lovers and professionals alike.",
            price: 199.99,
            originalPrice: 299.99,
            imageURL: "headphones",
            category: "Electronics",
            rating: 4.8,
            reviewCount: 2459,
            inStock: true,
            colors: ["Black", "White", "Navy"],
            sizes: nil
        ),
        Product(
            id: 2,
            name: "Smart Watch Pro",
            description: "Stay connected and track your fitness with our Smart Watch Pro. Features heart rate monitoring, GPS, water resistance up to 50m, and a stunning AMOLED display.",
            price: 349.99,
            originalPrice: 449.99,
            imageURL: "smartwatch",
            category: "Electronics",
            rating: 4.6,
            reviewCount: 1823,
            inStock: true,
            colors: ["Silver", "Black", "Rose Gold"],
            sizes: ["40mm", "44mm"]
        ),
        Product(
            id: 3,
            name: "Leather Crossbody Bag",
            description: "Handcrafted genuine leather crossbody bag with adjustable strap. Features multiple compartments, magnetic closure, and premium gold-tone hardware.",
            price: 89.99,
            originalPrice: 129.99,
            imageURL: "bag",
            category: "Fashion",
            rating: 4.7,
            reviewCount: 956,
            inStock: true,
            colors: ["Brown", "Black", "Tan"],
            sizes: nil
        ),
        Product(
            id: 4,
            name: "Running Shoes Ultra",
            description: "Lightweight and responsive running shoes with advanced cushioning technology. Breathable mesh upper and durable rubber outsole for maximum performance.",
            price: 129.99,
            originalPrice: 159.99,
            imageURL: "shoes",
            category: "Sports",
            rating: 4.5,
            reviewCount: 3241,
            inStock: true,
            colors: ["Blue/White", "Black/Red", "Gray/Green"],
            sizes: ["7", "8", "9", "10", "11", "12"]
        ),
        Product(
            id: 5,
            name: "Minimalist Desk Lamp",
            description: "Modern LED desk lamp with adjustable brightness and color temperature. Touch controls, USB charging port, and sleek aluminum design.",
            price: 59.99,
            originalPrice: nil,
            imageURL: "lamp",
            category: "Home",
            rating: 4.4,
            reviewCount: 678,
            inStock: true,
            colors: ["White", "Black"],
            sizes: nil
        ),
        Product(
            id: 6,
            name: "Organic Cotton T-Shirt",
            description: "Premium organic cotton t-shirt with a relaxed fit. Soft, breathable, and sustainably made. Perfect for everyday wear.",
            price: 34.99,
            originalPrice: 44.99,
            imageURL: "tshirt",
            category: "Fashion",
            rating: 4.3,
            reviewCount: 1245,
            inStock: true,
            colors: ["White", "Black", "Navy", "Gray", "Olive"],
            sizes: ["XS", "S", "M", "L", "XL", "XXL"]
        ),
        Product(
            id: 7,
            name: "Portable Bluetooth Speaker",
            description: "Powerful portable speaker with 360° sound, waterproof design, and 24-hour battery life. Connect multiple speakers for party mode.",
            price: 79.99,
            originalPrice: 99.99,
            imageURL: "speaker",
            category: "Electronics",
            rating: 4.6,
            reviewCount: 2156,
            inStock: true,
            colors: ["Black", "Blue", "Red"],
            sizes: nil
        ),
        Product(
            id: 8,
            name: "Yoga Mat Premium",
            description: "Extra-thick yoga mat with non-slip surface and alignment guides. Made from eco-friendly TPE material. Includes carrying strap.",
            price: 49.99,
            originalPrice: nil,
            imageURL: "yogamat",
            category: "Sports",
            rating: 4.8,
            reviewCount: 892,
            inStock: true,
            colors: ["Purple", "Blue", "Green", "Pink"],
            sizes: nil
        ),
        Product(
            id: 9,
            name: "Stainless Steel Water Bottle",
            description: "Double-walled vacuum insulated water bottle. Keeps drinks cold for 24 hours or hot for 12 hours. BPA-free and leak-proof.",
            price: 29.99,
            originalPrice: 39.99,
            imageURL: "bottle",
            category: "Home",
            rating: 4.7,
            reviewCount: 3567,
            inStock: true,
            colors: ["Silver", "Black", "Rose Gold", "Navy"],
            sizes: ["500ml", "750ml", "1L"]
        ),
        Product(
            id: 10,
            name: "Wireless Charging Pad",
            description: "Fast wireless charging pad compatible with all Qi-enabled devices. Sleek design with LED indicator and anti-slip surface.",
            price: 24.99,
            originalPrice: 34.99,
            imageURL: "charger",
            category: "Electronics",
            rating: 4.4,
            reviewCount: 1678,
            inStock: true,
            colors: ["Black", "White"],
            sizes: nil
        ),
        Product(
            id: 11,
            name: "Canvas Sneakers Classic",
            description: "Timeless canvas sneakers with rubber sole. Comfortable, versatile, and perfect for casual everyday style.",
            price: 54.99,
            originalPrice: nil,
            imageURL: "sneakers",
            category: "Fashion",
            rating: 4.5,
            reviewCount: 4523,
            inStock: true,
            colors: ["White", "Black", "Navy", "Red"],
            sizes: ["6", "7", "8", "9", "10", "11", "12"]
        ),
        Product(
            id: 12,
            name: "Aromatherapy Diffuser",
            description: "Ultrasonic essential oil diffuser with 7 LED colors and timer settings. Whisper-quiet operation and auto shut-off feature.",
            price: 39.99,
            originalPrice: 49.99,
            imageURL: "diffuser",
            category: "Home",
            rating: 4.6,
            reviewCount: 1234,
            inStock: true,
            colors: ["White", "Wood Grain"],
            sizes: nil
        )
    ]
}
