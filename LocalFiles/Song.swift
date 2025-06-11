//
//  Song.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

import UIKit
import AVFoundation

struct Song: Identifiable, Hashable {
    let id      = UUID()
    let url     : URL
    let title   : String
    let artist  : String
    let album   : String
    let artwork : UIImage?

    init(url: URL) {
        self.url = url
        let asset = AVAsset(url: url)

        // Title
        if let item = asset.commonMetadata.first(where: { $0.commonKey == .commonKeyTitle }),
           let value = item.stringValue {
            title = value
        } else {
            title = url.deletingPathExtension().lastPathComponent
        }

        // Artist
        if let item = asset.commonMetadata.first(where: { $0.commonKey == .commonKeyArtist }),
           let value = item.stringValue {
            artist = value
        } else {
            artist = "Unknown Artist"
        }

        // Album
        if let item = asset.commonMetadata.first(where: { $0.commonKey == .commonKeyAlbumName }),
           let value = item.stringValue {
            album = value
        } else {
            album = "Unknown Album"
        }

        // Artwork
        if let item = asset.commonMetadata.first(where: { $0.commonKey == .commonKeyArtwork }),
           let data = item.dataValue,
           let image = UIImage(data: data) {
            artwork = image
        } else {
            artwork = nil
        }
    }
}
