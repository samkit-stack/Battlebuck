//
//  ContentView.swift
//  Battlebuck
//
//  Created by Macbook Pro on 01/10/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PostsViewModel()
    
    var body: some View {
        TabView {
            PostsListView(viewModel: viewModel)
                .tabItem {
                    Label("Posts", systemImage: "list.bullet")
                }
            
            FavoritesView(viewModel: viewModel)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
    }
}

