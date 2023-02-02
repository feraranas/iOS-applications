//
//  MainView.swift
//  MyMusicApp
//
//  Created by Fernando Arana on 02/02/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var musicData = MusicViewModel()
    
    @State var width: CGFloat = UIScreen.main.bounds.height < 750 ? 130 : 230
    @State var timer = Timer.publish(every: 0.5, on: .current, in: .default).autoconnect()
    
    var buttons = ["suit.heart.fill", "star.fill", "eye.fill", "square.and.arrow.up.fill"]
    
    var body: some View {
        VStack {
            HStack {
                // app header
                Button(action:{}) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer(minLength: 0)
                
                Button(action: {}) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            VStack {
                // app main content
                Spacer(minLength: 0)
                
                ZStack {
                    // album artwork
                    Image(uiImage: musicData.album.artwork)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: width)
                        .clipShape(Circle())
                    
                    ZStack {
                        // Slider
                        Circle()
                            .trim(from: 0, to: 0.8)
                            .stroke(Color.black.opacity(0.06), lineWidth: 4)
                            .frame(width: width + 45, height: width + 45)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(musicData.angle) / 360)
                            .stroke(Color.blue, lineWidth: 4)
                            .frame(width: width + 45, height: width + 45)
                        
                        // Slider circle:
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 25, height: 25)
                            .offset(x: (width + 45) / 2)
                            .rotationEffect(.init(degrees: musicData.angle))
                        // gesture:
                            .gesture(DragGesture().onChanged(musicData.onChanged(value: )))
                        
                    }
                    // Rotation View
                    // 90 deg + 0.1 * 360 = 90 + 36
                    // total 126
                    .rotationEffect(.init(degrees: 126))
                    
                    // Time texts:
                    Text(musicData.getCurrentTime(value: musicData.player.currentTime))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .offset(x: UIScreen.main.bounds.height < 750 ? -65 : -85, y: (width + 60) / 2)
                    
                    Text(musicData.getCurrentTime(value: musicData.player.duration))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .offset(x: UIScreen.main.bounds.height < 750 ? -65 : 85, y: (width + 60) / 2)
                }
                
                Text(musicData.album.title)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                    .padding(.top, 25)
                    .padding(.horizontal)
                    .lineLimit(1)
                
                Text(musicData.album.artist)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                
                Text(musicData.album.type)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.vertical, 6)
                    .padding(.horizontal)
                    .background(Color.black.opacity(0.07))
                    .cornerRadius(10)
                    .padding(.top)
                
                HStack(spacing: 55) {
                    Button(action: musicData.rewind) {
                        Image(systemName: "backward.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: musicData.play) {
                        Image(systemName: musicData.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    
                    Button(action: musicData.forward) {
                        Image(systemName: "forward.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 25)
                
                // Volume
                HStack(spacing: 15) {
                    Image(systemName: "minus")
                        .foregroundColor(.black)
                    
                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                        Capsule()
                            .fill(Color.black.opacity(0.06))
                            .frame(height: 4)
                        Capsule()
                            .fill(Color.blue)
                            .frame(width: musicData.volume, height: 4)
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 30, height: 20)
                            .offset(x: musicData.volume)
                            .gesture(DragGesture().onChanged(musicData.updateVolume(value: )))
                    }
                    .frame(width: UIScreen.main.bounds.width - 160)
                    
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                }
                .padding(.top, 25)
                
                Spacer(minLength: 0)
            }
            .onAppear(perform: musicData.fetchAlbum)
            .onReceive(timer) { _ in
                musicData.updateTimer()
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(35)
            
            HStack {
                // app footer
                ForEach(buttons, id: \.self) { name in
                    Button(action: {}) {
                        Image(systemName: name)
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    if name != buttons.last {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, 35)
            .padding(.top, 25)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom != 0 ? 5: 15)
        }
        .background(
            VStack {
                Color(.blue).opacity(0.5)
                Color(.red)
            }.ignoresSafeArea(.all, edges: .all)
        )
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
