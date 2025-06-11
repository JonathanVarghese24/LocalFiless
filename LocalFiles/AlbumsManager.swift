//
//  AlbumsManager.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

// AlbumsManager.swift

import Foundation
import Combine

class AlbumsManager: ObservableObject {
    @Published private(set) var albums: [Album] = []
    private let saveKey = "LocalFiles.Albums"
    private var cancellables = Set<AnyCancellable>()

    init() {
        load()
        $albums
            .sink { [weak self] _ in self?.save() }
            .store(in: &cancellables)
    }

    func addAlbum(named name: String, with songIDs: [UUID]) {
        albums.append(Album(name: name, songIDs: songIDs))
    }

    func delete(at offsets: IndexSet) {
        albums.remove(atOffsets: offsets)
    }

    /// Add one or more songs to an existing album
    func addSongs(_ songIDs: [UUID], to album: Album) {
        guard let idx = albums.firstIndex(where: { $0.id == album.id }) else { return }
        for id in songIDs where !albums[idx].songIDs.contains(id) {
            albums[idx].songIDs.append(id)
        }
    }

    /// Remove songs at given offsets from an album
    func removeSongs(at offsets: IndexSet, from album: Album) {
        guard let idx = albums.firstIndex(where: { $0.id == album.id }) else { return }
        albums[idx].songIDs.remove(atOffsets: offsets)
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: saveKey),
            let decoded = try? JSONDecoder().decode([Album].self, from: data)
        else { return }
        albums = decoded
    }

    private func save() {
        if let data = try? JSONEncoder().encode(albums) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
}
