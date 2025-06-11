//
//  CreateAlbumView.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

import SwiftUI

struct CreateAlbumView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var manager: AlbumsManager
    let allSongs: [Song]

    @State private var name = ""
    @State private var selectedIDs = Set<UUID>()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Album Name")) {
                    TextField("Enter album name", text: $name)
                }
                Section(header: Text("Select Songs")) {
                    List(allSongs, id: \.id, selection: $selectedIDs) { song in
                        Text(song.title)
                    }
                    .environment(\.editMode, .constant(.active))
                }
            }
            .navigationTitle("New Album")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        manager.addAlbum(named: name, with: Array(selectedIDs))
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
