//
//  ProductCard.swift
//  Ecommerce
//

import SwiftUI

struct ProductCard: View {
    let product: Product
    @EnvironmentObject var cartManager: CartManager
    @State private var isAddingToCart = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Product Image
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.appSecondaryBackground,
                                Color.appSecondaryBackground.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        Image(systemName: productIcon)
                            .font(.system(size: 40))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.gradientStart, .gradientEnd],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                
                // Badges
                VStack(alignment: .leading, spacing: 4) {
                    if let discount = product.discountPercentage {
                        Text("-\(discount)%")
                            .font(.caption2.weight(.bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .clipShape(Capsule())
                    }
                    
                    if !product.inStock {
                        Text("Out of Stock")
                            .font(.caption2.weight(.medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray)
                            .clipShape(Capsule())
                    }
                }
                .padding(8)
            }
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.category)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(product.name)
                    .font(.subheadline.weight(.medium))
                    .lineLimit(2)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                // Rating
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(product.rating) ? "star.fill" : "star")
                            .font(.system(size: 10))
                            .foregroundColor(.yellow)
                    }
                    Text("(\(product.reviewCount))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                // Price
                HStack(spacing: 4) {
                    Text(product.formattedPrice)
                        .font(.headline)
                        .foregroundColor(.gradientStart)
                    
                    if let original = product.formattedOriginalPrice {
                        Text(original)
                            .font(.caption)
                            .strikethrough()
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Quick Add Button
                    Button(action: addToCart) {
                        Image(systemName: isAddingToCart ? "checkmark" : "plus")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.white)
                            .frame(width: 28, height: 28)
                            .background(
                                LinearGradient(
                                    colors: isAddingToCart ? [.green, .green] : [.gradientStart, .gradientEnd],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                    }
                    .disabled(!product.inStock || isAddingToCart)
                    .opacity(product.inStock ? 1 : 0.5)
                }
            }
        }
        .padding(12)
        .background(Color.appSecondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var productIcon: String {
        switch product.category {
        case "Electronics": return "headphones"
        case "Fashion": return "tshirt"
        case "Sports": return "figure.run"
        case "Home": return "lamp.desk"
        default: return "bag"
        }
    }
    
    private func addToCart() {
        isAddingToCart = true
        cartManager.addToCart(product)
        
        // Reset after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isAddingToCart = false
        }
    }
}

#Preview {
    ProductCard(product: Product.sampleProducts[0])
        .frame(width: 180)
        .environmentObject(CartManager())
}
