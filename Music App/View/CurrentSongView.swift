//
//  CurrentSongView.swift
//  Music App
//
//  Created by Sanskar Mishra on 7/22/23.
//

import SwiftUI
import SpotifyWebAPI
import Combine
import MarqueeText


struct CurrentSongView: View {
    
    @EnvironmentObject var spotify: Spotify
    
    
    let currentlyPlaying: PlaylistItem
    
    @State var isPlaying: Bool
    
    @State private var loadImageCancellable: AnyCancellable? = nil
    @State private var image = Image("NullAlbum")
    @State private var backgroundColor: Color = .clear
    
    @State var currentTrack: Track? = nil
    @State var currentEpisode: Episode? = nil
    @State var isTrack: Bool = true
    
    
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 330, height: 90)
                .background(backgroundColor)
                .cornerRadius(20)
            
            HStack{
                Spacer()
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipped()
                
                VStack(alignment: .leading){
                    Spacer()
                    
                    if isTrack {
                        
                        MarqueeText(
                             text: currentTrack?.name ?? "Track Name",
                             font: UIFont(name: "Inter-SemiBold", size: 18)!,
                             leftFade: 3,
                             rightFade: 3,
                             startDelay: 3
                             )
                        .foregroundColor(.white)
                        .frame(maxWidth: 150)
                        
                        
                        MarqueeText(
                             text: currentTrack?.artists?.first?.name ?? "Artist Name",
                             font: UIFont(name: "Inter-Regular", size: 18)!,
                             leftFade: 3,
                             rightFade: 3,
                             startDelay: 3
                             )
                        .foregroundColor(.white)
                        .frame(maxWidth: 150)
                    }
                    else{
                        
                        MarqueeText(
                             text: currentEpisode?.name ?? "Episode Name",
                             font: UIFont(name: "Inter-Regular", size: 18)!,
                             leftFade: 5,
                             rightFade: 5,
                             startDelay: 3
                             )
                        .foregroundColor(.white)
                        
                        
                        MarqueeText(
                             text: currentEpisode?.show?.name ?? "Show Name",
                             font: UIFont(name: "Inter-SemiBold", size: 18)!,
                             leftFade: 8,
                             rightFade: 8,
                             startDelay: 2
                             )
                        .foregroundColor(.white)
                        
                    }
          
                    Spacer()
                }
                .padding(.trailing)
                
                
                AudioVisualizer(isPlaying: self.isPlaying).scaleEffect(x: 0.75, y: 0.75)
            
                Spacer()
                
                
                
            }
        }
        .frame(width: 330, height: 110)
        .padding(.bottom)
        .onAppear{
        
            
            switch currentlyPlaying {
            case .track(let track):
                isTrack = true
                currentTrack = track
            case .episode(let episode):
                isTrack = false
                currentEpisode = episode
            }
            loadImage()
            }
        }
    
    func loadImage() {
        guard let spotifyImage = currentTrack?.album?.images?.first else {
            return
        }

        self.loadImageCancellable = spotifyImage.load()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { image in
                    self.image = image
                    self.setAverageColor()


                }
            )
    }

    func setAverageColor() {
       let image: Image = self.image // Create an Image anyhow you want
       let uiImage: UIImage = image.asUIImage() // Works Perfectly
       
        let uiColor = uiImage.averageColor ?? .darkGray
        
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        print(b)
        
        if b > 0.75{
            //var surplus = (b - 0.5) / 2
            backgroundColor = Color(uiColor.modified(withAdditionalHue: 0, additionalSaturation: 0, additionalBrightness: -0.5))
        }
        else if b > 0.5{
            backgroundColor = Color(uiColor.modified(withAdditionalHue: 0, additionalSaturation: 0, additionalBrightness: -0.25))
        }
        else if b < 0.1{
            backgroundColor = Color(uiColor.modified(withAdditionalHue: 0, additionalSaturation: 0, additionalBrightness: 0.2))
        }
        else{
            backgroundColor = Color(uiColor)
        }
        
       
   //    let uiColor = UIImage(named: images[currentIndex])?.averageColor ?? .clear
      // backgroundColor = Color(uiColor)
   }
 }



//struct CurrentSongView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrentSongView(track)
//    }
//}
