# EndgameGlobalDevTest
iOS Coding Challenge for Endgame Global - GitHub User Search App

## Features

- **User Search**: Real-time search of GitHub users with debounced input
- **User Profiles**: Profile view with avatar, stats, and GitHub profile link
- **Loading States**: Loading indicators and error handling
- **Empty States**: Helpful guidance for users with contextual messages
- **Image Caching**: Efficient avatar loading with memory caching
- **Swift 6 Safety**: Modern concurrency with async/await and actor isolation

## Architecture

### MVVM (Model-View-ViewModel)
The app follows MVVM architecture pattern with clear separation of concerns:

- **Models**: Data structures (`User`, `UserProfile`, `GitHubSearchResponse`)
- **Components**: UIKit components (`UserCellTemplate`, `StatView`)
- **ViewModels**: Business logic (`ListingViewModel`, `UserDetailViewModel`)
- **Services**: API and utility services (`GitHubAPIService`, `ImageLoadingService`)

## Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 15.0+
- Swift 6.0

### Installation
1. Clone the repository:
    https://github.com/yourusername/EndgameGlobalDevTest.git
2. Open EndgameGlobalChallenge.xcodeproj in Xcode
3. Build and run the project

## Technical Implementation

### API Integration
- **GitHub API**: Uses GitHub's public search API (/search/users and /users/{username})
- **URLSession**: Native networking with async/await
- **Error Handling**: Error states including rate limiting

### Swift 6 Features
- **Actor Isolation**: Thread-safe API and image loading services
- **async/await**: Modern concurrency throughout the app
- **Sendable Types**: Thread-safe data models
- **@MainActor**: UI updates on main thread

### Performance Optimizations
- **Debounced Search**: 500ms delay to prevent excessive API calls
- **Image Caching**: NSCache-based avatar caching with memory management
- **Lazy Loading**: Table view cell reuse

## Libraries & Dependencies
None! This project uses only native iOS frameworks:

- UIKit (UI components)
- Foundation (Core functionality)
- XCTest (Unit testing)

## Future Enhancements

Given more time, I would implement the following features:

1. **Core Data Integration**
- Persistent local storage for user search results
- Offline browsing of previously viewed profiles
- Search history with autocomplete suggestions
- Merge cached and live data with visual indicators

2. **Enhanced User Experience**
- Pull-to-refresh functionality
- Infinite scroll pagination for large result sets