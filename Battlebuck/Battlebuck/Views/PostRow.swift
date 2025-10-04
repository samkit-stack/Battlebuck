//
//  PostRow.swift
//  Battlebuck
//
//  Created by Macbook Pro on 04/10/25.
//

import SwiftUI
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
