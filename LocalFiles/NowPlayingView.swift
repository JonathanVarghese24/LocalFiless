//
//  NowPlayingView.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

import SwiftUI

struct NowPlayingView: View {
    @ObservedObject var audioManager: AudioPlayerManager
    let song: Song?

    var body: some View {
        VStack {
            if let song = song {
                Spacer()

                Image(uiImage: song.artwork ?? UIImage(systemName: "music.note")!)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                    .padding()

                Text(song.title)
                    .font(.title2)
                    .padding(.top, 4)
                Text(song.artist)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Slider(
                    value: $audioManager.currentTime,
                    in: 0...audioManager.duration
                ) {
                    Text("Seek")
                } onEditingChanged: { editing in
                    if !editing {
                        audioManager.seek(to: audioManager.currentTime)
                    }
                }
                .padding()

                HStack {
                    Spacer()
                    Button { /* prev */ } label: {
                        Image(systemName: "backward.fill")
                            .font(.largeTitle)
                    }
                    Spacer()
                    Button {
                        audioManager.isPlaying
                            ? audioManager.pause()
                            : audioManager.play()
                    } label: {
                        Image(systemName:
                              audioManager.isPlaying
                              ? "pause.circle.fill"
                              : "play.circle.fill")
                            .font(.system(size: 60))
                    }
                    Spacer()
                    Button { /* next */ } label: {
                        Image(systemName: "forward.fill")
                            .font(.largeTitle)
                    }
                    Spacer()
                }
                .padding(.bottom)

                Spacer()
            } else {
                Text("No song selected")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Now Playing")
    }
}
