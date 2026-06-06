# Top 100 Albums

A SwiftUI iOS app that displays Apple Music's top 100 most-played albums, built as a practice project.

## Features

- Fetches live data from the Apple RSS Marketing Tools API
- Scrollable list of the top 100 most-played albums
- Detail view for each album showing artwork, artist, genres, release date, and a link to Apple Music

## Architecture

The project follows MVVM with a layered service architecture:

```
View  →  ViewModel  →  AlbumService  →  ApiService  →  URLSession
```

- **View layer** — `MainView` (list), `AlbumView` (row), `AlbumDetailView` (detail)
- **ViewModel** — `MainViewModel` uses `@Observable` and exposes a `LoadingState<[Album]>` enum (`idle`, `loading`, `finished`, `error`)
- **AlbumService** — `actor` that deduplicates in-flight fetch requests using task coalescing
- **ApiService** — generic HTTP layer built on `URLSession` with protocol-based abstraction for testability

## Tech Stack

- Swift 6 / SwiftUI
- `@Observable` macro for state management
- Swift Concurrency (`async/await`, `actor`)
- Apple RSS Marketing Tools API

## Requirements

- Xcode 16+
- iOS 17+

## Getting Started

1. Clone the repo
2. Open `nike_swiftui.xcodeproj` in Xcode
3. Select a simulator or device and run
