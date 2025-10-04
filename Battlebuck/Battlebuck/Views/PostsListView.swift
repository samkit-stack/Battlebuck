//
//  PostsListView.swift
//  Battlebuck
//
//  Created by Macbook Pro on 04/10/25.
//

import SwiftUI
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
