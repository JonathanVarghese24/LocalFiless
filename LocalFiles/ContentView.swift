//
//  ContentView.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

// ContentView.swift

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var audioManager     = AudioPlayerManager()
    @StateObject private var playlistsManager = PlaylistsManager()
    @StateObject private var albumsManager    = AlbumsManager()

    @State private var songs: [Song]        = []
    @State private var showImporter         = false
    @State private var selectedSong: Song?  = nil

    private var documentsURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
    }

    var body: some View {
        TabView {
            // Songs Tab
            NavigationView {
                VStack {
                    Button("Import Songs") { showImporter = true }
                        .padding(.top)

                    List {
                        ForEach(songs) { song in
                            SongRow(song: song) { play(song) }
                        }
                        .onDelete(perform: deleteSongs)
                    }
                    .navigationTitle("Library")
                }
                .fileImporter(
                    isPresented: $showImporter,
                    allowedContentTypes: [.audio],
                    allowsMultipleSelection: true
                ) { result in
                    handleImport(result)
                }
            }
            .tabItem { Label("Songs", systemImage: "music.note.list") }

            // Albums Tab
            NavigationView {
                AlbumsView(
                    manager: albumsManager,
                    songs: songs,
                    playAction: play(_:),
                    selected: $selectedSong
                )
            }
            .tabItem { Label("Albums", systemImage: "rectangle.stack") }

            // Playlists Tab
            NavigationView {
                PlaylistsView(
                    manager: playlistsManager,
                    songs: songs,
                    playAction: play(_:),
                    selected: $selectedSong
                )
            }
            .tabItem { Label("Playlists", systemImage: "list.bullet.rectangle") }

            // Now Playing Tab
            NavigationView {
                NowPlayingView(audioManager: audioManager,
                               song: selectedSong)
            }
            .tabItem { Label("Now Playing", systemImage: "play.circle") }
        }
        .onAppear(perform: loadSongs)
    }

    private func play(_ song: Song) {
        selectedSong = song
        audioManager.playSong(song)
    }

    private func deleteSongs(at offsets: IndexSet) {
        for idx in offsets {
            let s = songs[idx]
            try? FileManager.default.removeItem(at: s.url)
        }
        songs.remove(atOffsets: offsets)
    }

    private func loadSongs() {
        let urls = (try? FileManager.default.contentsOfDirectory(
            at: documentsURL,
            includingPropertiesForKeys: nil)) ?? []
        songs = urls
            .filter { ["mp3","m4a"].contains($0.pathExtension.lowercased()) }
            .map(Song.init)
    }

    private func handleImport(_ result: Result<[URL], Error>) {
        showImporter = false
        guard case .success(let urls) = result else { return }
        for url in urls {
            guard url.startAccessingSecurityScopedResource() else { continue }
            defer { url.stopAccessingSecurityScopedResource() }
            let dst = documentsURL.appendingPathComponent(url.lastPathComponent)
            if !FileManager.default.fileExists(atPath: dst.path) {
                try? FileManager.default.copyItem(at: url, to: dst)
            }
        }
        loadSongs()
    }
}
