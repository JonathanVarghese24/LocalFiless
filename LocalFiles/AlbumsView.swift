//
//  AlbumsView.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

import SwiftUI

struct AlbumsView: View {
    @ObservedObject var manager: AlbumsManager
    let songs: [Song]
    let playAction: (Song) -> Void
    @Binding var selected: Song?

    @State private var showCreator = false

    var body: some View {
        List {
            ForEach(manager.albums) { album in
                NavigationLink(destination:
                    AlbumDetailView(
                        album: album,
                        songs: songs.filter { album.songIDs.contains($0.id) },
                        play: playAction,
                        selected: $selected
                    )
                ) {
                    Text(album.name)
                }
            }
            .onDelete(perform: manager.delete)
        }
        .navigationTitle("Albums")
        .toolbar {
            Button { showCreator = true } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showCreator) {
            CreateAlbumView(manager: manager, allSongs: songs)
        }
    }
}
