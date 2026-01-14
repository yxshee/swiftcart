//
//  FilterSheet.swift
//  Ecommerce
//

import SwiftUI

struct FilterSheet: View {
    @Binding var filters: ProductFilters
    @Environment(\.dismiss) private var dismiss
    
    @State private var localFilters: ProductFilters = ProductFilters()
    @State private var priceRange: ClosedRange<Double> = 0...500
    
    let categories = ["Electronics", "Fashion", "Sports", "Home"]
    let priceRanges = [
        ("Under $50", 0.0, 50.0),
        ("$50 - $100", 50.0, 100.0),
        ("$100 - $200", 100.0, 200.0),
        ("$200 - $500", 200.0, 500.0),
        ("Over $500", 500.0, 9999.0)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Categories
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Category")
                            .font(.headline)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                FilterChip(
                                    title: category,
                                    isSelected: localFilters.category == category
                                ) {
                                    if localFilters.category == category {
                                        localFilters.category = nil
                                    } else {
                                        localFilters.category = category
                                    }
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Price Range
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Price Range")
                            .font(.headline)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(priceRanges, id: \.0) { range in
                                FilterChip(
                                    title: range.0,
                                    isSelected: localFilters.minPrice == range.1 && localFilters.maxPrice == range.2
                                ) {
                                    if localFilters.minPrice == range.1 && localFilters.maxPrice == range.2 {
                                        localFilters.minPrice = nil
                                        localFilters.maxPrice = nil
                                    } else {
                                        localFilters.minPrice = range.1
                                        localFilters.maxPrice = range.2
                                    }
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Availability
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Availability")
                            .font(.headline)
                        
                        Toggle(isOn: $localFilters.inStockOnly) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("In Stock Only")
                                    .font(.subheadline)
                            }
                        }
                        .tint(.gradientStart)
                        .padding()
                        .background(Color.appSecondaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset") {
                        localFilters.reset()
                    }
                    .foregroundColor(.secondary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        filters = localFilters
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button(action: {
                    filters = localFilters
                    dismiss()
                }) {
                    Text("Apply Filters")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.gradientStart, .gradientEnd],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
        .onAppear {
            localFilters = filters
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    isSelected ?
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
                        .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

// MARK: - Flow Layout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        var height: CGFloat = 0
        var currentX: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentX + size.width > maxWidth {
                currentX = 0
                height += currentRowHeight + spacing
                currentRowHeight = 0
            }
            
            currentX += size.width + spacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
        
        height += currentRowHeight
        
        return CGSize(width: maxWidth, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentX + size.width > bounds.maxX {
                currentX = bounds.minX
                currentY += currentRowHeight + spacing
                currentRowHeight = 0
            }
            
            subview.place(at: CGPoint(x: currentX, y: currentY), proposal: .unspecified)
            
            currentX += size.width + spacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
    }
}

#Preview {
    FilterSheet(filters: .constant(ProductFilters()))
}
