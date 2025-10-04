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

// MARK: - Posts List
struct PostsListView: View {
    @ObservedObject var viewModel: PostsViewModel
    @State private var hasLoaded = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    errorView(error)
                } else {
                    postsListContent
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Posts")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.top,6)
                }
            }
            .onAppear {
                if !hasLoaded && viewModel.posts.isEmpty {
                    hasLoaded = true
                    Task {
                        await viewModel.loadPosts()
                    }
                }
            }
        }
    }
    
    private var postsListContent: some View {
        NavigationStack{
            //            VStack(spacing: 0) {
            List(viewModel.filteredPosts) { post in
                NavigationLink(destination: PostDetailView(post: post, viewModel: viewModel)) {
                    PostRow(post: post, viewModel: viewModel)
                        .padding(.vertical, 6)
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
            //               }
            .searchable(text: $viewModel.searchText, prompt: "Search posts...")
        }
        .refreshable {
            if(NetworkService.shared.isNetworkAvailable){
                await viewModel.loadPosts()
            }
            // THIS IS CRASHING IF INTERNET NOT AVAILABLE WILL NEED TO DEBUG THE REASON FOR SAME
        }
    }
    
    // HAD TO MAKE SEARCHABLE AWAY FROM LIST DUE TO A SWIFTUI HEIRARCHY ISSUE CAUSING IT TO HIDE AS WE REFRESHED

    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.orange.opacity(0.3), Color.red.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "wifi.slash")
                    .font(.system(size: 35))
                    .foregroundColor(.orange)
            }
            
            VStack(spacing: 8) {
                Text("Connection Failed")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button {
                Task {
                    await viewModel.loadPosts()
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(Color.blue)
                )
            }
        }
        .padding()
    }
}

struct PostRow: View {
    let post: Post
    @ObservedObject var viewModel: PostsViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Text("#\(post.id)")
                    .font(.caption2.bold())
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(post.title)
                    .font(.headline)
                    .lineLimit(2)
                Text("👤 User \(post.userId)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                withAnimation(.spring()) {
                    viewModel.toggleFavorite(post.id)
                }
            } label: {
                Image(systemName: viewModel.isFavorite(post.id) ? "heart.fill" : "heart")
                    .foregroundColor(viewModel.isFavorite(post.id) ? .red : .gray)
                    .imageScale(.large)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(viewModel.isFavorite(post.id) ? Color.red.opacity(0.15) : Color.gray.opacity(0.15))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding()
    }
}



// MARK: - Detail View
struct PostDetailView: View {
    let post: Post
    @ObservedObject var viewModel: PostsViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(post.title.capitalized)
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                        Spacer()
                        Button {
                            withAnimation(.spring()) {
                                viewModel.toggleFavorite(post.id)
                            }
                        } label: {
                            Image(systemName: viewModel.isFavorite(post.id) ? "heart.fill" : "heart")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(viewModel.isFavorite(post.id) ? Color.red : Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    }
                    
                    Text("By User \(post.userId)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)], startPoint: .top, endPoint: .bottom))
                )
                
                // Body
                VStack(alignment: .leading, spacing: 12) {
                    Text("📖 Content")
                        .font(.headline)
                    Text(post.body)
                        .font(.body)
                        .lineSpacing(6)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
                )
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}

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
