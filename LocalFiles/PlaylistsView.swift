//
//  PlaylistsView.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//
//working

// PlaylistsView.swift
import SwiftUI

struct PlaylistsView: View {
    @ObservedObject var manager: PlaylistsManager
    let songs: [Song]
    let playAction: (Song) -> Void
    @Binding var selected: Song?

    @State private var showCreator = false

    var body: some View {
        List {
            ForEach(manager.playlists) { playlist in
                NavigationLink(destination:
                    PlaylistDetailView(
                        manager: manager,
                        playlist: playlist,
                        allSongs: songs,
                        playAction: playAction,
                        selected: $selected
                    )
                ) {
                    Text(playlist.name)
                }
            }
            .onDelete(perform: manager.delete)
        }
        .navigationTitle("Playlists")
        .toolbar {
            Button { showCreator = true } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showCreator) {
            CreatePlaylistView(manager: manager, allSongs: songs)
        }
    }
}
