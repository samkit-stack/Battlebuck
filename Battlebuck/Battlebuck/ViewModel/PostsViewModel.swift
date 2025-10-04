//
//  PostsViewModel.swift
//  Battlebuck
//
//  Created by Macbook Pro on 03/10/25.
//
// MARK: - ViewModel For Following MVVM
import SwiftUI
@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var favoriteIds: Set<Int> = [] {
        didSet {
            saveFavorites()
        }
    }
    
    private var loadTask: Task<Void, Never>?
    private let favoritesKey = "fav_post_ids"
    
    init() {
        loadFavorites()
    }
    
    var filteredPosts: [Post] {
        guard !searchText.isEmpty else { return posts }
        return posts.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var favoritePosts: [Post] {
        posts.filter { favoriteIds.contains($0.id) }
    }
    
    func loadPosts() async {
        loadTask?.cancel()
        
        loadTask = Task {
            guard !Task.isCancelled else { return }
            
            isLoading = true
            errorMessage = nil
            
            do {
                let fetchedPosts = try await NetworkService.shared.fetchPosts()
                guard !Task.isCancelled else { return }
                
                posts = fetchedPosts
                isLoading = false
            } catch {
                guard !Task.isCancelled else { return }
                
                errorMessage = "Failed to load posts. Please try again."
                print("Error \(error)")
                isLoading = false
            }
        }
        
        await loadTask?.value
    }
    
    func toggleFavorite(_ postId: Int) {
        if favoriteIds.contains(postId) {
            favoriteIds.remove(postId)
        } else {
            favoriteIds.insert(postId)
        }
    }
    
    func isFavorite(_ postId: Int) -> Bool {
        favoriteIds.contains(postId)
    }
    
    // SAVED FOR OFFLINE EXPERIENCE
    private func saveFavorites() {
        let ids = Array(favoriteIds)
        UserDefaults.standard.set(ids, forKey: favoritesKey)
    }
    
    private func loadFavorites() {
        if let saved = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] {
            favoriteIds = Set(saved)
        }
    }
}
