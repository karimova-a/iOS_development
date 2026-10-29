//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Aigerim Karimova on 29.10.2026.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController, AVAudioPlayerDelegate {
    //Outlets
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var elapsedLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    //Stats
    private let tracks = TrackLibrary.tracks
    private var currentIndex = 0
    private var isPlaying = false
    private var player: AVAudioPlayer?
    private var progressTimer: Timer?
    private var favorites: Set<String> = []
    private let favoritesKey = "favoriteTracks"
    
    //Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        favorites = Set(UserDefaults.standard.stringArray(forKey: favoritesKey) ?? [])
        configureAudioSession()
        loadCurrentTrack()
        refreshUI()
        startProgressTimer()
    }
    
    deinit {
        progressTimer?.invalidate()
    }
    
    //Actions
    @IBAction func playPauseTapped(_ sender: UIButton) {
        guard let player = player else {
            print("No player available for track: \(tracks[currentIndex].fileName)")
            return
        }
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            isPlaying = player.play()
        }
        refreshUI()
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        changeTrack(to: (currentIndex + 1) % tracks.count)
    }
    
    @IBAction func previousTapped(_ sender: UIButton){
        changeTrack(to: (currentIndex - 1 + tracks.count) % tracks.count)
    }
    
    @IBAction func favoriteTapped(_ sender: UIButton){
        let id = tracks[currentIndex].fileName
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        UserDefaults.standard.set(Array(favorites), forKey: favoritesKey)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        guard let player = player else {
            sender.value = 0
            return
        }
        let target = Double(sender.value) * player.duration
        player.currentTime = min(target, max(player.duration - 0.1, 0))
        elapsedLabel.text = format(player.currentTime)
    }
    
    //Track handlinf
    private func changeTrack(to index: Int) {
        let wasPlaying = isPlaying
        currentIndex = index
        loadCurrentTrack()
        if wasPlaying {
            isPlaying = player?.play() ?? false
        }
        refreshUI()
    }
    
    private func loadCurrentTrack() {
        player?.stop()
        player = nil
        
        let track = tracks[currentIndex]
        let name = (track.fileName as NSString).deletingPathExtension
        let ext = (track.fileName as NSString).pathExtension
        
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("⚠️ File not found in bundle: \(track.fileName)")
            isPlaying = false
            return
        }
        
        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.delegate = self
            newPlayer.prepareToPlay()
            player = newPlayer
        } catch {
            print("⚠️ Could not create player for \(track.fileName): \(error)")
            isPlaying = false
        }
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("⚠️ Audio session error: \(error)")
        }
    }
    
    //Progree
    private func startProgressTimer() {
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) {
            [weak self] _ in self?.updateProgress()
        }
    }
    
    private func updateProgress() {
        guard let player = player else {
            progressSlider.value = 0
            elapsedLabel.text = format(0)
            durationLabel.text = format(0)
            return
        }
        durationLabel.text = format(player.duration)
        if !progressSlider.isTracking {
            progressSlider.value = player.duration > 0 ? Float(player.currentTime / player.duration) : 0
            elapsedLabel.text = format(player.currentTime)
        }
    }

    private func format(_ time: TimeInterval) -> String {
        let total = Int(time)
        return String(format: "%d:%02d", total / 60, total % 60)
    }

    //UI
    private func refreshUI() {
        let track = tracks[currentIndex]
        titleLabel.text = track.title
        artistLabel.text = track.artist
        coverImageView.image = UIImage(named: track.coverImageName)

        let playSymbol = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: playSymbol), for: .normal)

        let starSymbol = favorites.contains(track.fileName) ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: starSymbol), for: .normal)

        updateProgress()
    }

    //AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = true
        changeTrack(to: (currentIndex + 1) % tracks.count)
    }
}
  

