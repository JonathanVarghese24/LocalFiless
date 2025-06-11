//
//  PlaylistDetailView.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

// PlaylistDetailView.swift

import SwiftUI

struct PlaylistDetailView: View {
    @ObservedObject var manager: PlaylistsManager
    let playlist: Playlist
    let allSongs: [Song]
    let playAction: (Song) -> Void
    @Binding var selected: Song?

    @State private var showAdd = false

    // Songs currently in this playlist
    private var songs: [Song] {
        allSongs.filter { playlist.songIDs.contains($0.id) }
    }

    var body: some View {
        List {
            ForEach(songs) { song in
                SongRow(song: song) {
                    selected = song
                    playAction(song)
                }
            }
            .onDelete { offsets in
                manager.removeSongs(at: offsets, from: playlist)
            }
        }
        .navigationTitle(playlist.name)
        .toolbar {
            Button { showAdd = true } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showAdd) {
            let available = allSongs.filter { !playlist.songIDs.contains($0.id) }
            AddSongsView(
                title: "Add to \(playlist.name)",
                allSongs: available
            ) { selectedIDs in
                manager.addSongs(Array(selectedIDs), to: playlist)
            }
        }
    }
}
