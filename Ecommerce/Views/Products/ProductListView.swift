//
//  ProductListView.swift
//  Ecommerce
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var productStore: ProductStore
    @EnvironmentObject var cartManager: CartManager
    
    @State private var showFilters = false
    @State private var showSort = false
    @State private var isGridView = true
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Featured Section
                if !productStore.featuredProducts.isEmpty && productStore.searchText.isEmpty {
                    FeaturedSection(products: productStore.featuredProducts)
                        .padding(.bottom, 24)
                }
                
                // Categories
                CategoryScrollView(
                    categories: productStore.categories,
                    selectedCategory: $productStore.selectedCategory
                )
                .padding(.bottom, 16)
                
                // Sort and Filter Bar
                HStack {
                    Text("\(productStore.filteredProducts.count) Products")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action: { showSort = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: productStore.selectedSort.icon)
                            Text(productStore.selectedSort.displayName)
                                .font(.subheadline)
                        }
                        .foregroundColor(.primary)
                    }
                    
                    Button(action: { showFilters = true }) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    .padding(.leading, 12)
                    
                    Button(action: { withAnimation { isGridView.toggle() } }) {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    .padding(.leading, 8)
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                // Product Grid/List
                if productStore.isLoading {
                    LoadingView()
                        .frame(height: 300)
                } else if productStore.filteredProducts.isEmpty {
                    EmptyStateView(
                        icon: "magnifyingglass",
                        title: "No Products Found",
                        message: "Try adjusting your search or filters"
                    )
                    .frame(height: 300)
                } else {
                    if isGridView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(productStore.filteredProducts) { product in
                                NavigationLink(value: product) {
                                    ProductCard(product: product)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(productStore.filteredProducts) { product in
                                NavigationLink(value: product) {
                                    ProductListRow(product: product)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Load More
                    if productStore.hasMorePages {
                        Button(action: {
                            Task { await productStore.loadMoreProducts() }
                        }) {
                            if productStore.isLoadingMore {
                                ProgressView()
                                    .padding()
                            } else {
                                Text("Load More")
                                    .font(.subheadline.weight(.medium))
                                    .padding()
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Shop")
        .searchable(text: $productStore.searchText, prompt: "Search products...")
        .refreshable {
            await productStore.refresh()
        }
        .navigationDestination(for: Product.self) { product in
            ProductDetailView(product: product)
        }
        .sheet(isPresented: $showFilters) {
            FilterSheet(filters: $productStore.filters)
        }
        .confirmationDialog("Sort By", isPresented: $showSort, titleVisibility: .visible) {
            ForEach(SortOption.allCases, id: \.self) { option in
                Button(option.displayName) {
                    productStore.setSort(option)
                }
            }
        }
    }
}

// MARK: - Featured Section
struct FeaturedSection: View {
    let products: [Product]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Featured Deals")
                    .font(.title2.weight(.bold))
                
                Spacer()
                
                Text("🔥")
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(products) { product in
                        NavigationLink(value: product) {
                            FeaturedProductCard(product: product)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Featured Product Card
struct FeaturedProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                // Product Image
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [.gradientStart.opacity(0.3), .gradientEnd.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 180, height: 120)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.7))
                    }
                
                // Discount Badge
                if let discount = product.discountPercentage {
                    Text("-\(discount)%")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .padding(8)
                }
            }
            
            Text(product.name)
                .font(.subheadline.weight(.medium))
                .lineLimit(1)
            
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
            }
        }
        .frame(width: 180)
    }
}

// MARK: - Category Scroll View
struct CategoryScrollView: View {
    let categories: [String]
    @Binding var selectedCategory: String?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    CategoryChip(
                        title: category,
                        isSelected: selectedCategory == category || (selectedCategory == nil && category == "All")
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category == "All" ? nil : category
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                    AnyShapeStyle(LinearGradient(
                        colors: [.gradientStart, .gradientEnd],
                        startPoint: .leading,
                        endPoint: .trailing
                    )) :
                    AnyShapeStyle(Color(uiColor: .secondarySystemBackground))
                )
                .clipShape(Capsule())
        }
    }
}

// MARK: - Product List Row
struct ProductListRow: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 12) {
            // Image placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .secondarySystemBackground))
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: "photo")
                        .foregroundColor(.secondary)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.subheadline.weight(.medium))
                    .lineLimit(2)
                
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", product.rating))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("(\(product.reviewCount))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
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
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        ProductListView()
    }
    .environmentObject(ProductStore())
    .environmentObject(CartManager())
}
