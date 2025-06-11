//
//  PlaylistsView.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

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
                        playlist: playlist,
                        songs: songs.filter { playlist.songIDs.contains($0.id) },
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

struct PlaylistDetailView: View {
    let playlist: Playlist
    let songs: [Song]
    let playAction: (Song) -> Void
    @Binding var selected: Song?

    var body: some View {
        List(songs) { song in
            SongRow(song: song) {
                selected = song
                playAction(song)
            }
        }
        .navigationTitle(playlist.name)
    }
}

struct CreatePlaylistView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var manager: PlaylistsManager
    let allSongs: [Song]

    @State private var name = ""
    @State private var selectedIDs = Set<UUID>()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Playlist Name")) {
                    TextField("Enter name", text: $name)
                }
                Section(header: Text("Select Songs")) {
                    List(allSongs, id: \.id, selection: $selectedIDs) { song in
                        Text(song.title)
                    }
                    .environment(\.editMode, .constant(.active))
                }
            }
            .navigationTitle("New Playlist")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        manager.addPlaylist(named: name, with: Array(selectedIDs))
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
