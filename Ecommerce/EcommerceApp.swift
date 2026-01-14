//
//  EcommerceApp.swift
//  Ecommerce
//
//  SwiftUI Ecommerce Application
//

import SwiftUI

@main
struct EcommerceApp: App {
    @StateObject private var cartManager = CartManager()
    @StateObject private var productStore = ProductStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cartManager)
                .environmentObject(productStore)
        }
    }
}
