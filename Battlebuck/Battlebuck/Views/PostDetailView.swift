//
//  PostDetailView.swift
//  Battlebuck
//
//  Created by Macbook Pro on 04/10/25.
//

import SwiftUI
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
