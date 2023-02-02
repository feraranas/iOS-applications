//
//  LoopingPlayer.swift
//  VideoTest
//
//  Created by Fernando Arana on 30/01/23.
//

import Foundation
import SwiftUI
import AVFoundation


// construimos una instancia del reproductor de video
// en uikit es nativa, en swiftui construimos un puente: UIViewRepresentable
struct LoopingPlayer: UIViewRepresentable {
    
    // una vista de tipo UIView es la forma nativa en que las interfaces en UIkit corresponden a este elemento
    // en el momento en que retornamos una UIView, SwiftUI la coloca en nuestra interfaz gráfica
    func makeUIView(context: Context) -> some UIView {
        return QueuePlayerUIView(frame: .zero)
    }
    
    // para conformar con el protocolo necesitamos esta función
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
}

class QueuePlayerUIView: UIView {
    
    // esta capa permite insertar el streaming de video en la pantalla
    private var playerLayer = AVPlayerLayer()
    
    // creamos un iterador, optional
    private var playerLooper: AVPlayerLooper?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let fileUrl = Bundle.main.url(forResource: "timer",
                                      withExtension: "mov")!
        
        let playerItem = AVPlayerItem(url: fileUrl)
        
        // establecemos el reproductor
        let player = AVQueuePlayer(playerItem: playerItem)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        // Loop:
        playerLooper = AVPlayerLooper(player: player,
                                      templateItem: playerItem)
        
        // Play:
        player.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) is not implemented")
    }
}

// NOTA: las clases son mutables, a diferencia de struct
// en esta clase añadimos únicamente la capa
class PlayerUIView: UIView{
    private var playerLayer = AVPlayerLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let fileUrl = Bundle.main.url(forResource: "timer", withExtension: "mov")!
        let playerItem = AVPlayerItem(url: fileUrl)
        
        // Setup player
        let player = AVQueuePlayer(playerItem: playerItem)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        // Loop
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(rewindVideo(notification: )),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        
        // Play
        player.play()
    }
    
    @objc func rewindVideo(notification: Notification) {
        playerLayer.player?.seek(to: .zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) is not implemented")
    }
}


