//
//  AlbumsManager.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

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
