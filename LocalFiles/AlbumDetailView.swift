//
//  AlbumDetailView.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

import SwiftUI

struct AlbumDetailView: View {
    let album: Album
    let songs: [Song]
    let play: (Song) -> Void
    @Binding var selected: Song?

    var body: some View {
        List(songs) { song in
            SongRow(song: song) {
                selected = song
                play(song)
            }
        }
        .navigationTitle(album.name)
    }
}
