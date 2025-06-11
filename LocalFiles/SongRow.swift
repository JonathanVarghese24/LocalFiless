//
//  SongRow.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

import SwiftUI

struct SongRow: View {
    let song: Song
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(uiImage: song.artwork ?? UIImage(systemName: "music.note")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(4)
                VStack(alignment: .leading) {
                    Text(song.title)
                        .font(.headline)
                    Text(song.artist)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
