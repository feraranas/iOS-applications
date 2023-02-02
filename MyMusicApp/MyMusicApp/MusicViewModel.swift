//
//  MusicViewModel.swift
//  MyMusicApp
//
//  Created by Fernando Arana on 02/02/23.
//

import Foundation
import SwiftUI
import AVKit



class MusicViewModel: ObservableObject {
    
    static let url = URL(fileURLWithPath: Bundle.main.path(forResource: "song", ofType: "mp3")!)
    
    @Published var player = try! AVAudioPlayer(contentsOf: MusicViewModel.url)
    
    @Published var isPlaying = false
    
    @Published var album = Album()
    
    @Published var angle: Double = 0
    
    @Published var volume: CGFloat = 0
    
    func fetchAlbum() {
        let asset = AVAsset(url: player.url!)
        
        asset.metadata.forEach { (meta) in
            
            switch(meta.commonKey?.rawValue) {
            case "title": album.title = meta.value as? String ?? ""
            case "artist": album.artist = meta.value as? String ?? ""
            case "type": album.type = meta.value as? String ?? ""
            case "artwork": if meta.value != nil {
                album.artwork = UIImage(data: meta.value as! Data)!}
            default: ()
            }
        }
        
        volume = CGFloat(player.volume) * (UIScreen.main.bounds.width - 180)
    }
    
    func updateTimer() {
        let currentTime = player.currentTime
        
        let total = player.duration
        
        let progress = currentTime / total
        
        withAnimation(Animation.linear(duration: 0.1)) {
            self.angle = Double(progress) * 288
        }
        
        isPlaying = player.isPlaying
    }
    
    func onChanged(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        let radians = atan2(vector.dy - 12.5, vector.dx - 12.5)
        
        let tempAngle = radians * 180 / .pi
        
        let angle = tempAngle < 0 ? 360 + tempAngle : tempAngle
        
        if angle <= 288 {
            let progress = angle / 288
            let time = TimeInterval(progress) * player.duration
            player.currentTime = time
            player.play()
            
            withAnimation(Animation.linear(duration: 0.1)) {
                self.angle = Double(angle)
            }
        }
    }
    
    func play() {
        if player.isPlaying {
            player.pause()
        }
        else {
            player.play()
        }
        
        isPlaying = player.isPlaying
    }
    
    func getCurrentTime(value: TimeInterval) -> String {
        return "\(Int(value / 60)):\(Int(value.truncatingRemainder(dividingBy: 60)) < 9 ? "0":"")\(Int(value.truncatingRemainder(dividingBy: 60)))"
    }
    
    func updateVolume(value: DragGesture.Value) {
        if value.location.x >= 0 && value.location.x <= UIScreen.main.bounds.width - 180 {
            let progress = value.location.x / UIScreen.main.bounds.width - 180
            player.volume = Float(progress)
            withAnimation(Animation.linear(duration: 0.1)) {
                volume = value.location.x
                print("Volume: \(volume)")
            }
        }
    }
    
    func forward() {
        let angle = self.angle + ((0.5 * 180) / .pi)
        if angle > 0 && angle <= 288 {
            let progress = angle / 288
            let time = TimeInterval(progress) * player.duration
            player.currentTime = time
            player.play()
            withAnimation(Animation.linear(duration: 0.1)) {
                self.angle = Double(angle)
            }
        }
    }
    
    func rewind() {
        let angle = self.angle - ((0.5 * 180) / .pi)
        if angle > 0 && angle <= 288 {
            let progress = angle / 288
            let time = TimeInterval(progress) * player.duration
            player.currentTime = time
            player.play()
            withAnimation(Animation.linear(duration: 0.1)) {
                self.angle = Double(angle)
            }
        }
    }
}
