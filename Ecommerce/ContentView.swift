//
//  ContentView.swift
//  Ecommerce
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        TabView {
            NavigationStack {
                ProductListView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            NavigationStack {
                CartView()
            }
            .tabItem {
                Image(systemName: "cart.fill")
                Text("Cart")
            }
            .badge(cartManager.itemCount)
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
        .tint(Color("AccentColor"))
    }
}

#Preview {
    ContentView()
        .environmentObject(CartManager())
        .environmentObject(ProductStore())
}
