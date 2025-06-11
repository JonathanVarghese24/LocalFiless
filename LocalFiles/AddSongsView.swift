//
//  AddSongsView.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

// AddSongsView.swift

import SwiftUI

/// A sheet allowing the user to multi-select from allSongs and return the selected IDs on Save.
struct AddSongsView: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let allSongs: [Song]
    @State private var selectedIDs: Set<UUID> = []
    let onSave: (Set<UUID>) -> Void

    var body: some View {
        NavigationView {
            List(allSongs, id: \.id, selection: $selectedIDs) { song in
                HStack {
                    Text(song.title)
                    Spacer()
                    if selectedIDs.contains(song.id) {
                        Image(systemName: "checkmark")
                    }
                }
            }
            .environment(\.editMode, .constant(.active))
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onSave(selectedIDs)
                        dismiss()
                    }
                    .disabled(selectedIDs.isEmpty)
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
