//
//  ContentView.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

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
            // Songs
            NavigationView { songsList }
                .tabItem { Label("Songs", systemImage: "music.note.list") }

            // Albums
            NavigationView {
                AlbumsView(
                    manager: albumsManager,
                    songs: songs,
                    playAction: play(_:),
                    selected: $selectedSong
                )
            }
            .tabItem { Label("Albums", systemImage: "rectangle.stack") }

            // Playlists
            NavigationView {
                PlaylistsView(
                    manager: playlistsManager,
                    songs: songs,
                    playAction: play(_:),
                    selected: $selectedSong
                )
            }
            .tabItem { Label("Playlists", systemImage: "list.bullet.rectangle") }

            // Now Playing
            NavigationView {
                NowPlayingView(audioManager: audioManager,
                               song: selectedSong)
            }
            .tabItem { Label("Now Playing", systemImage: "play.circle") }
        }
        .onAppear(perform: loadSongs)
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: [.mp3, .mpeg4Audio],
            allowsMultipleSelection: true
        ) { handleImport($0) }
    }

    private var songsList: some View {
        VStack {
            Button("Import Songs") { showImporter = true }
                .padding(.top)

            List(songs) { song in
                SongRow(song: song) { play(song) }
            }
        }
        .navigationTitle("Library")
    }

    private func play(_ song: Song) {
        selectedSong = song
        audioManager.playSong(song)
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
        if case .success(let urls) = result {
            for url in urls {
                let dest = documentsURL.appendingPathComponent(url.lastPathComponent)
                if !FileManager.default.fileExists(atPath: dest.path) {
                    try? FileManager.default.copyItem(at: url, to: dest)
                }
            }
            loadSongs()
        }
    }
}
