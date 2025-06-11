//
//  PlaylistsManager.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

// PlaylistsManager.swift

import Foundation
import Combine

class PlaylistsManager: ObservableObject {
    @Published private(set) var playlists: [Playlist] = []
    private let saveKey = "LocalFiles.Playlists"
    private var cancellables = Set<AnyCancellable>()

    init() {
        load()
        $playlists
            .sink { [weak self] _ in self?.save() }
            .store(in: &cancellables)
    }

    func addPlaylist(named name: String, with songIDs: [UUID]) {
        playlists.append(Playlist(name: name, songIDs: songIDs))
    }

    func delete(at offsets: IndexSet) {
        playlists.remove(atOffsets: offsets)
    }

    /// Add one or more songs to an existing playlist
    func addSongs(_ songIDs: [UUID], to playlist: Playlist) {
        guard let idx = playlists.firstIndex(where: { $0.id == playlist.id }) else { return }
        for id in songIDs where !playlists[idx].songIDs.contains(id) {
            playlists[idx].songIDs.append(id)
        }
    }

    /// Remove songs at given offsets from a playlist
    func removeSongs(at offsets: IndexSet, from playlist: Playlist) {
        guard let idx = playlists.firstIndex(where: { $0.id == playlist.id }) else { return }
        playlists[idx].songIDs.remove(atOffsets: offsets)
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: saveKey),
            let decoded = try? JSONDecoder().decode([Playlist].self, from: data)
        else { return }
        playlists = decoded
    }

    private func save() {
        if let data = try? JSONEncoder().encode(playlists) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
}
