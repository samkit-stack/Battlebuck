# 🚀 Battlebuck – SwiftUI Posts Assignment

A simple SwiftUI app that fetches posts from a remote API, supports search, favorites, and offline storage — all built using **MVVM architecture**.

---

## 📦 Setup Instructions

1. **Clone the repository**
```bash
git clone https://github.com/samkit-stack/Battlebuck
cd PostsApp
Open the project in Xcode

bash
Copy code
open PostsApp.xcodeproj
Run the app

Select your target device or simulator

Build & Run → ⌘ + R

📱 Requirements
iOS: 15.0+

Xcode: 14.0+

Swift: 5.7+

🏛 Architecture (MVVM)
The app follows the Model–View–ViewModel (MVVM) pattern for clean separation of concerns:

Model
Post:
Codable struct representing post data from API
Conforms to Identifiable & Equatable for SwiftUI

View
ContentView: Root view with TabView
PostsListView: Main list with search & pull-to-refresh
PostRowView: Reusable row component with favorite button
PostDetailView: Detail screen showing full post content
FavoritesView: Dedicated favorites list

ViewModel
PostsViewModel
Manages app state (@Published properties)
Handles business logic (filtering, favorites)
Coordinates network calls

Published properties:
posts
favoritePosts
searchText
isLoading
errorMessage

Computed properties:
filteredPosts
favorites

Network Layer
NetworkService:

Singleton service for API calls
Separated from ViewModel for testability
Uses async/await
Proper error handling with NetworkError enum

✨ Features Implemented
🔄 Offline Storage – Caches the latest data for offline usage
❤️ Favorites Persistence – Favorites are stored offline for a smooth UX

🚧 Future Improvements
Move offline storage to Realm/CoreData
Make the UI more interactive & animated
Add unit tests for ViewModel and network layer
Add UI tests for user flows & interactions
Full Dark Mode support


