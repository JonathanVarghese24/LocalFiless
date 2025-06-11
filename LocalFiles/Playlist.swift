//
//  Playlist.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

import Foundation

struct Playlist: Identifiable, Codable {
    let id     : UUID
    var name   : String
    var songIDs: [UUID]

    init(name: String, songIDs: [UUID] = []) {
        self.id      = UUID()
        self.name    = name
        self.songIDs = songIDs
    }
}
