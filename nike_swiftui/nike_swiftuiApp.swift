//
//  nike_swiftuiApp.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import SwiftUI

@main
struct nike_swiftuiApp: App {
    @State private var viewModel = MainViewModel(
        albumDataProvider: AlbumDataProvider(apiService: ApiService())
    )

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(viewModel)
        }
    }
}
