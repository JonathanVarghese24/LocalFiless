//
//  AudioPlayerManager.swift
//  LocalFiles
//
//  Created by JV on 6/11/25.
//

import Foundation
import AVFoundation
import MediaPlayer

class AudioPlayerManager: ObservableObject {
    @Published var isPlaying   = false
    @Published var currentTime = TimeInterval(0)
    @Published var duration    = TimeInterval(0)

    private var player: AVAudioPlayer?
    private var timer: Timer?
    private var currentSong: Song?

    init() { setupRemoteTransportControls() }

    func playSong(_ song: Song) {
        stop()
        currentSong = song
        do {
            player = try AVAudioPlayer(contentsOf: song.url)
            player?.prepareToPlay()
            duration = player?.duration ?? 0
            player?.play()
            isPlaying = true
            startTimer()
            updateNowPlayingInfo()
        } catch {
            print("⚠️ Playback error:", error)
        }
    }

    func play() {
        guard player != nil else { return }
        player?.play()
        isPlaying = true
        startTimer()
        updateNowPlayingInfo()
    }

    func pause() {
        player?.pause()
        isPlaying = false
        stopTimer()
        updateNowPlayingInfo()
    }

    func stop() {
        player?.stop()
        isPlaying = false
        stopTimer()
    }

    func seek(to time: TimeInterval) {
        player?.currentTime = time
        currentTime = time
        updateNowPlayingInfo()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let s = self, let p = s.player else { return }
            s.currentTime = p.currentTime
            s.updateNowPlayingInfo()
        }
    }
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: – Remote & Lock-Screen Controls

    private func setupRemoteTransportControls() {
        let cc = MPRemoteCommandCenter.shared()
        cc.playCommand.addTarget { [unowned self] _ in self.play(); return .success }
        cc.pauseCommand.addTarget { [unowned self] _ in self.pause(); return .success }
        cc.changePlaybackPositionCommand.addTarget { [unowned self] event in
            guard let e = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            self.seek(to: e.positionTime); return .success
        }
    }

    private func updateNowPlayingInfo() {
        guard let song = currentSong else { return }
        var info: [String: Any] = [
            MPMediaItemPropertyTitle:               song.title,
            MPMediaItemPropertyArtist:              song.artist,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPMediaItemPropertyPlaybackDuration:    duration
        ]
        if let art = song.artwork {
            info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(
                boundsSize: art.size
            ) { _ in art }
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
}
