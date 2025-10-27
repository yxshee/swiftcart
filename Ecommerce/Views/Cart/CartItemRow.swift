//
//  CartItemRow.swift
//  Ecommerce
//

import SwiftUI

struct CartItemRow: View {
    let item: CartItem
    @EnvironmentObject var cartManager: CartManager
    @State private var isRemoving = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Product Image
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(uiColor: .secondarySystemBackground),
                            Color(uiColor: .tertiarySystemBackground)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: productIcon)
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.gradientStart, .gradientEnd],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            
            // Product Info
            VStack(alignment: .leading, spacing: 6) {
                Text(item.product.name)
                    .font(.subheadline.weight(.medium))
                    .lineLimit(2)
                
                // Options
                if let color = item.selectedColor, let size = item.selectedSize {
                    Text("\(color) • \(size)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if let color = item.selectedColor {
                    Text(color)
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if let size = item.selectedSize {
                    Text("Size: \(size)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text(item.product.formattedPrice)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.gradientStart)
                    
                    Spacer()
                    
                    // Quantity Controls
                    HStack(spacing: 0) {
                        Button(action: { cartManager.decrementQuantity(item) }) {
                            Image(systemName: item.quantity == 1 ? "trash" : "minus")
                                .font(.caption.weight(.medium))
                                .foregroundColor(item.quantity == 1 ? .red : .primary)
                                .frame(width: 32, height: 32)
                                .background(Color(uiColor: .secondarySystemBackground))
                        }
                        
                        Text("\(item.quantity)")
                            .font(.subheadline.weight(.medium))
                            .frame(width: 36)
                        
                        Button(action: { cartManager.incrementQuantity(item) }) {
                            Image(systemName: "plus")
                                .font(.caption.weight(.medium))
                                .foregroundColor(.primary)
                                .frame(width: 32, height: 32)
                                .background(Color(uiColor: .secondarySystemBackground))
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(isRemoving ? 0.5 : 1)
        .scaleEffect(isRemoving ? 0.95 : 1)
        .animation(.easeInOut(duration: 0.2), value: isRemoving)
    }
    
    private var productIcon: String {
        switch item.product.category {
        case "Electronics": return "headphones"
        case "Fashion": return "tshirt"
        case "Sports": return "figure.run"
        case "Home": return "lamp.desk"
        default: return "bag"
        }
    }
}

#Preview {
    CartItemRow(item: CartItem(product: Product.sampleProducts[0], quantity: 2))
        .padding()
        .environmentObject(CartManager())
}
