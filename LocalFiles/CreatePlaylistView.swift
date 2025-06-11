//
//  CreatePlaylistView.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

// CreatePlaylistView.swift

import SwiftUI

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
                    TextField("Enter playlist name", text: $name)
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
