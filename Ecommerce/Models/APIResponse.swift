//
//  APIResponse.swift
//  Ecommerce
//

import Foundation

// MARK: - Generic API Response
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let message: String?
    let error: String?
}

// MARK: - Pagination
struct PaginatedResponse<T: Codable>: Codable {
    let items: T
    let pagination: PaginationInfo
}

struct PaginationInfo: Codable {
    let currentPage: Int
    let totalPages: Int
    let totalItems: Int
    let itemsPerPage: Int
    
    var hasNextPage: Bool {
        return currentPage < totalPages
    }
    
    var hasPreviousPage: Bool {
        return currentPage > 1
    }
}

// MARK: - Product List Response
struct ProductListResponse: Codable {
    let products: [Product]
    let pagination: PaginationInfo
    let filters: AvailableFilters?
}

struct AvailableFilters: Codable {
    let categories: [String]
    let priceRange: PriceRange
}

struct PriceRange: Codable {
    let min: Double
    let max: Double
}

// MARK: - Sort Options
enum SortOption: String, CaseIterable {
    case newest = "newest"
    case priceAsc = "price_asc"
    case priceDesc = "price_desc"
    case rating = "rating"
    case popular = "popular"
    
    var displayName: String {
        switch self {
        case .newest: return "Newest"
        case .priceAsc: return "Price: Low to High"
        case .priceDesc: return "Price: High to Low"
        case .rating: return "Highest Rated"
        case .popular: return "Most Popular"
        }
    }
    
    var icon: String {
        switch self {
        case .newest: return "clock"
        case .priceAsc: return "arrow.up"
        case .priceDesc: return "arrow.down"
        case .rating: return "star.fill"
        case .popular: return "flame.fill"
        }
    }
}

// MARK: - Filter Parameters
struct ProductFilters {
    var category: String?
    var minPrice: Double?
    var maxPrice: Double?
    var inStockOnly: Bool = false
    var searchQuery: String = ""
    
    var isEmpty: Bool {
        return category == nil && 
               minPrice == nil && 
               maxPrice == nil && 
               !inStockOnly && 
               searchQuery.isEmpty
    }
    
    mutating func reset() {
        category = nil
        minPrice = nil
        maxPrice = nil
        inStockOnly = false
        searchQuery = ""
    }
}
