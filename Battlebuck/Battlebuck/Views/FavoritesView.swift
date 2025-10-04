//
//  FavoritesView.swift
//  Battlebuck
//
//  Created by Macbook Pro on 04/10/25.
//
import SwiftUI
// MARK: - Favorites
struct FavoritesView: View {
    @ObservedObject var viewModel: PostsViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.favoritePosts.isEmpty {
                    emptyState
                } else {
                    favoritesList
                }
            }
            .navigationTitle("Favorites")
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.pink.opacity(0.4), .purple.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "heart.slash")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            
            Text("No Favorites Yet ❤️")
                .font(.title2.bold())
            
            Text("Save posts you like by tapping the heart icon.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    
    private var favoritesList: some View {
        List(viewModel.favoritePosts) { post in
            NavigationLink(destination: PostDetailView(post: post, viewModel: viewModel)) {
                PostRow(post: post, viewModel: viewModel)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [Color.softColor(for: post.id), Color.softColor(for: post.id).opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                    )
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }
}
