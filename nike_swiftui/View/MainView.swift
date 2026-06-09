//
//  ContentView.swift
//  nike_swiftui
//
//  Created by davidlee on 6/6/26.
//

import SwiftUI

struct MainView: View {
    @Environment(MainViewModel.self) private var viewModel
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.albums {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .finished:
                    List(viewModel.filteredAlbums(matching: searchText)) { album in
                        NavigationLink(destination: AlbumDetailView(album: album)) {
                            AlbumView(album: album)
                        }
                    }
                case .error(let error):
                    Text(error.localizedDescription)
                }
            }
            .navigationTitle("Top Albums")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search albums")
        }
        .task {
            await viewModel.fetchAlbums()
        }
    }
}

#Preview {
    MainView()
}
