//
//  NetworkManager.swift
//  Battlebuck
//
//  Created by Macbook Pro on 03/10/25.
//
// MARK: - Networking Layer Made Singleton for Easy Access
import SwiftUI

import Foundation
import Network

// MARK: - Networking
class NetworkService {
    static let shared = NetworkService()
    private init() {
        startNetworkMonitoring()
    }
    
    private let cacheKey = "cached_posts"
    private let cacheTimestampKey = "cache_timestamp"
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
  
    private(set) var isNetworkAvailable: Bool = false
    
    private func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("🌐 Internet is available")
                self?.isNetworkAvailable = true
            } else {
                print("🚫 No internet connection")
                self?.isNetworkAvailable = false
            }
        }
        monitor.start(queue: queue)
    }
    
    // MARK: - Fetch Posts
    func fetchPosts() async throws -> [Post] {
        do {
            print("Attempting to fetch from API...")
            let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let posts = try JSONDecoder().decode([Post].self, from: data)
            
            // Cache the fresh data
            saveToDisk(posts)
            print("✅ Fetched from API and cached \(posts.count) posts")
            
            return posts
            
        } catch {
            // If network fails, try to load from cache
           
            if let cachedPosts = loadFromDisk() {
               
                return cachedPosts
            } else {
                print("❌ No cached data available")
                throw error
            }
        }
    }
    
    // MARK: - Caching
    private func saveToDisk(_ posts: [Post]) {
        do {
            let data = try JSONEncoder().encode(posts)
            UserDefaults.standard.set(data, forKey: cacheKey)
            UserDefaults.standard.set(Date(), forKey: cacheTimestampKey)
        } catch {
            print("Failed \(error)")
        }
    }
    
    private func loadFromDisk() -> [Post]? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else {
            return nil
        }
        
        do {
            let posts = try JSONDecoder().decode([Post].self, from: data)
            return posts
        } catch {
            print("Failed \(error)")
            return nil
        }
    }
    

    
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
      
    }
}

