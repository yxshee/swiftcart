# API Documentation

## Overview

This document describes the API endpoints that the ShopNow app is designed to integrate with. Currently, the app uses **mock/sample data** for demonstration purposes.

---

## Base URL

```
https://api.example.com/v1
```

## Authentication

Most endpoints require authentication using JWT tokens.

```http
Authorization: Bearer <your_jwt_token>
```

---

## Endpoints

### Products

#### Get Products (with Pagination, Filtering, Sorting)

```http
GET /products
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `page` | integer | No | Page number (default: 1) |
| `limit` | integer | No | Items per page (default: 20, max: 100) |
| `category` | string | No | Filter by category |
| `minPrice` | number | No | Minimum price filter |
| `maxPrice` | number | No | Maximum price filter |
| `search` | string | No | Search products by name/description |
| `sort` | string | No | Sort option: `newest`, `price_asc`, `price_desc`, `rating`, `popular` |
| `inStock` | boolean | No | Filter in-stock items only |

**Example Request:**
```http
GET /products?page=1&limit=20&category=electronics&minPrice=100&maxPrice=500&sort=price_asc
```

**Example Response:**
```json
{
  "success": true,
  "data": {
    "products": [
      {
        "id": 1,
        "name": "Premium Wireless Headphones",
        "description": "High-quality wireless headphones...",
        "price": 199.99,
        "originalPrice": 299.99,
        "imageURL": "https://cdn.example.com/products/headphones.jpg",
        "category": "Electronics",
        "rating": 4.8,
        "reviewCount": 2459,
        "inStock": true,
        "colors": ["Black", "White", "Navy"],
        "sizes": null
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 5,
      "totalItems": 100,
      "itemsPerPage": 20
    }
  },
  "filters": {
    "categories": ["Electronics", "Fashion", "Sports", "Home"],
    "priceRange": {
      "min": 0,
      "max": 999
    }
  }
}
```

---

#### Get Single Product

```http
GET /products/:id
```

**Example Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Premium Wireless Headphones",
    "description": "Detailed product description...",
    "price": 199.99,
    "originalPrice": 299.99,
    "imageURL": "https://cdn.example.com/products/headphones.jpg",
    "images": [
      "https://cdn.example.com/products/headphones-1.jpg",
      "https://cdn.example.com/products/headphones-2.jpg"
    ],
    "category": "Electronics",
    "rating": 4.8,
    "reviewCount": 2459,
    "inStock": true,
    "colors": ["Black", "White", "Navy"],
    "sizes": null,
    "specifications": {
      "battery": "30 hours",
      "connectivity": "Bluetooth 5.0",
      "weight": "250g"
    }
  }
}
```

---

### Orders

#### Create Order

```http
POST /orders
```

**Request Body:**
```json
{
  "items": [
    {
      "productId": 1,
      "productName": "Premium Wireless Headphones",
      "price": 199.99,
      "quantity": 2,
      "selectedColor": "Black",
      "selectedSize": null
    }
  ],
  "shippingAddress": {
    "fullName": "Yash Dogra",
    "streetAddress": "123 Main Street",
    "city": "San Francisco",
    "state": "CA",
    "zipCode": "94102",
    "country": "United States",
    "phoneNumber": "+1234567890"
  },
  "paymentMethod": "credit_card"
}
```

**Example Response:**
```json
{
  "success": true,
  "data": {
    "id": "ORD-123456",
    "items": [...],
    "shippingAddress": {...},
    "paymentMethod": "credit_card",
    "subtotal": 399.98,
    "tax": 31.99,
    "shippingCost": 0,
    "total": 431.97,
    "status": "confirmed",
    "createdAt": "2026-01-14T21:00:00Z",
    "estimatedDelivery": "2026-01-19T00:00:00Z"
  }
}
```

---

#### Get Order

```http
GET /orders/:id
```

**Example Response:**
```json
{
  "success": true,
  "data": {
    "id": "ORD-123456",
    "status": "shipped",
    "trackingNumber": "1Z999AA10123456784",
    "items": [...],
    "total": 431.97,
    "createdAt": "2026-01-14T21:00:00Z",
    "shippedAt": "2026-01-15T10:00:00Z"
  }
}
```

---

#### Get User Orders

```http
GET /orders?userId=<user_id>&page=1&limit=10
```

---

### User Authentication

#### Register

```http
POST /auth/register
```

**Request Body:**
```json
{
  "name": "Yash Dogra",
  "email": "yxshdogra@gmail.com",
  "password": "securePassword123",
  "phoneNumber": "+917876205914"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user-123",
      "name": "Yash Dogra",
      "email": "yxshdogra@gmail.com"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

---

#### Login

```http
POST /auth/login
```

**Request Body:**
```json
{
  "email": "yxshdogra@gmail.com",
  "password": "securePassword123"
}
```

---

### Cart (Server-side sync - optional)

#### Get Cart

```http
GET /cart
```

#### Update Cart

```http
POST /cart
```

**Request Body:**
```json
{
  "items": [
    {
      "productId": 1,
      "quantity": 2,
      "selectedColor": "Black",
      "selectedSize": null
    }
  ]
}
```

---

## Error Responses

All endpoints return errors in the following format:

```json
{
  "success": false,
  "error": {
    "code": "PRODUCT_NOT_FOUND",
    "message": "The requested product could not be found"
  }
}
```

### Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 400 | Invalid request parameters |
| `UNAUTHORIZED` | 401 | Missing or invalid authentication |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `NOT_FOUND` | 404 | Resource not found |
| `CONFLICT` | 409 | Resource conflict (e.g., duplicate) |
| `SERVER_ERROR` | 500 | Internal server error |

---

## Rate Limiting

- **Rate Limit:** 100 requests per minute per IP
- **Headers:**
  - `X-RateLimit-Limit`: Request limit
  - `X-RateLimit-Remaining`: Remaining requests
  - `X-RateLimit-Reset`: Time when limit resets

---

## Integration Guide

### 1. Update Base URL

In `NetworkManager.swift`:

```swift
private let baseURL = "https://your-api.com/v1"
```

### 2. Update ProductStore

Replace sample data in `ProductStore.swift`:

```swift
func loadInitialData() {
    isLoading = true
    
    Task {
        do {
            let response: ProductListResponse = try await NetworkManager.shared.fetchProducts(
                page: 1,
                limit: 20
            )
            self.products = response.products
            self.totalPages = response.pagination.totalPages
            self.isLoading = false
        } catch {
            self.error = error.localizedDescription
            self.isLoading = false
        }
    }
}
```

### 3. Add Authentication

Store JWT token securely:

```swift
// Using Keychain or UserDefaults (for development)
@AppStorage("authToken") private var authToken: String = ""
```

Add to NetworkManager headers:

```swift
func fetch<T: Decodable>(endpoint: String, ...) async throws -> T {
    var request = URLRequest(url: url)
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    // ... rest of implementation
}
```

---

## Testing

Use tools like:
- **Postman** - API testing
- **Charles Proxy** - Network debugging
- **MockServer** - Mock API responses

---

## Webhook Events (Future)

For real-time updates:

```json
{
  "event": "order.status_updated",
  "data": {
    "orderId": "ORD-123456",
    "status": "shipped",
    "trackingNumber": "1Z999AA10123456784"
  }
}
```
