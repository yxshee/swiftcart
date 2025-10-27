//
//  ProductDetailView.swift
//  Ecommerce
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var productStore: ProductStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedColor: String?
    @State private var selectedSize: String?
    @State private var quantity: Int = 1
    @State private var showAddedToCart = false
    @State private var isFavorite = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Product Image
                productImageSection
                
                // Product Info
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    headerSection
                    
                    Divider()
                    
                    // Color Selection
                    if let colors = product.colors, !colors.isEmpty {
                        colorSelectionSection(colors: colors)
                    }
                    
                    // Size Selection
                    if let sizes = product.sizes, !sizes.isEmpty {
                        sizeSelectionSection(sizes: sizes)
                    }
                    
                    // Quantity
                    quantitySection
                    
                    Divider()
                    
                    // Description
                    descriptionSection
                    
                    Divider()
                    
                    // Related Products
                    relatedProductsSection
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    Button(action: { isFavorite.toggle() }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .primary)
                    }
                    
                    ShareLink(item: product.name) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomBar
        }
        .onAppear {
            selectedColor = product.colors?.first
            selectedSize = product.sizes?.first
        }
        .overlay {
            if showAddedToCart {
                addedToCartOverlay
            }
        }
    }
    
    // MARK: - Product Image Section
    private var productImageSection: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                colors: [
                    Color.appSecondaryBackground,
                    Color.appSecondaryBackground.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 350)
            .overlay {
                Image(systemName: productIcon)
                    .font(.system(size: 100))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.gradientStart, .gradientEnd],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            // Discount Badge
            if let discount = product.discountPercentage {
                Text("-\(discount)% OFF")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.red)
                    .clipShape(Capsule())
                    .padding()
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.category)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(product.name)
                .font(.title2.weight(.bold))
            
            // Rating
            HStack(spacing: 4) {
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(product.rating) ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                }
                
                Text(String(format: "%.1f", product.rating))
                    .font(.subheadline.weight(.medium))
                
                Text("(\(product.reviewCount) reviews)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Price
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(product.formattedPrice)
                    .font(.title.weight(.bold))
                    .foregroundColor(.gradientStart)
                
                if let original = product.formattedOriginalPrice {
                    Text(original)
                        .font(.title3)
                        .strikethrough()
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Stock Status
                HStack(spacing: 4) {
                    Circle()
                        .fill(product.inStock ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    Text(product.inStock ? "In Stock" : "Out of Stock")
                        .font(.caption)
                        .foregroundColor(product.inStock ? .green : .red)
                }
            }
        }
    }
    
    // MARK: - Color Selection
    private func colorSelectionSection(colors: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Color: \(selectedColor ?? "")")
                .font(.subheadline.weight(.medium))
            
            HStack(spacing: 12) {
                ForEach(colors, id: \.self) { color in
                    Button(action: { selectedColor = color }) {
                        Text(color)
                            .font(.caption.weight(.medium))
                            .foregroundColor(selectedColor == color ? .white : .primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                selectedColor == color ?
                                AnyShapeStyle(LinearGradient(
                                    colors: [.gradientStart, .gradientEnd],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )) :
                                AnyShapeStyle(Color.appSecondaryBackground)
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(selectedColor == color ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
    
    // MARK: - Size Selection
    private func sizeSelectionSection(sizes: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Size: \(selectedSize ?? "")")
                .font(.subheadline.weight(.medium))
            
            HStack(spacing: 12) {
                ForEach(sizes, id: \.self) { size in
                    Button(action: { selectedSize = size }) {
                        Text(size)
                            .font(.caption.weight(.medium))
                            .foregroundColor(selectedSize == size ? .white : .primary)
                            .frame(minWidth: 44)
                            .padding(.vertical, 10)
                            .background(
                                selectedSize == size ?
                                AnyShapeStyle(LinearGradient(
                                    colors: [.gradientStart, .gradientEnd],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )) :
                                AnyShapeStyle(Color.appSecondaryBackground)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedSize == size ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
    
    // MARK: - Quantity Section
    private var quantitySection: some View {
        HStack {
            Text("Quantity")
                .font(.subheadline.weight(.medium))
            
            Spacer()
            
            HStack(spacing: 0) {
                Button(action: { if quantity > 1 { quantity -= 1 } }) {
                    Image(systemName: "minus")
                        .font(.caption.weight(.bold))
                        .foregroundColor(quantity > 1 ? .primary : .secondary)
                        .frame(width: 36, height: 36)
                        .background(Color.appSecondaryBackground)
                }
                .disabled(quantity <= 1)
                
                Text("\(quantity)")
                    .font(.headline)
                    .frame(width: 50)
                
                Button(action: { quantity += 1 }) {
                    Image(systemName: "plus")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.primary)
                        .frame(width: 36, height: 36)
                        .background(Color.appSecondaryBackground)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    // MARK: - Description Section
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(.headline)
            
            Text(product.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
    }
    
    // MARK: - Related Products Section
    private var relatedProductsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("You May Also Like")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(productStore.relatedProducts(for: product)) { relatedProduct in
                        NavigationLink(value: relatedProduct) {
                            ProductCard(product: relatedProduct)
                                .frame(width: 160)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
    
    // MARK: - Bottom Bar
    private var bottomBar: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Total")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(String(format: "$%.2f", product.price * Double(quantity)))
                    .font(.title2.weight(.bold))
            }
            
            Button(action: addToCart) {
                HStack {
                    Image(systemName: "cart.badge.plus")
                    Text("Add to Cart")
                        .fontWeight(.semibold)
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
            .disabled(!product.inStock)
            .opacity(product.inStock ? 1 : 0.5)
        }
        .padding()
        .background(.ultraThinMaterial)
    }
    
    // MARK: - Added to Cart Overlay
    private var addedToCartOverlay: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Added to Cart!")
                .font(.title3.weight(.semibold))
        }
        .padding(40)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .transition(.scale.combined(with: .opacity))
    }
    
    // MARK: - Helpers
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
        cartManager.addToCart(
            product,
            quantity: quantity,
            color: selectedColor,
            size: selectedSize
        )
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showAddedToCart = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showAddedToCart = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: Product.sampleProducts[0])
    }
    .environmentObject(CartManager())
    .environmentObject(ProductStore())
}
