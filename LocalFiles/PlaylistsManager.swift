//
//  PlaylistsManager.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

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
