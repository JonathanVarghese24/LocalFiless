//
//  LocalFilesApp.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

import SwiftUI
import AVFoundation

@main
struct LocalFilesApp: App {
    init() { configureAudioSession() }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            print("⚠️ Audio session config failed:", error)
        }
    }
}
