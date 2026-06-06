//
//  ContentView.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import SwiftUI

struct MainView: View {
    @Environment(MainViewModel.self) private var viewModel

    var body: some View {
        Group {
            switch viewModel.albums {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .finished(let albums):
                List(albums) { album in
                    AlbumView(album: album)
                }
            case .error(let error):
                Text(error.localizedDescription)
            }
        }
        .task {
            await viewModel.fetchAlbums()
        }
        .padding()
    }
}

#Preview {
    MainView()
}
