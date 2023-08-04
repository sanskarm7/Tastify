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
    
    //let track: Track
    
    let currentlyPlaying: PlaylistItem
    
    @State var isPlaying: Bool
    
    @State private var loadImageCancellable: AnyCancellable? = nil
    @State private var image = Image("NullAlbum")
    @State private var backgroundColor: Color = .clear
    
    @State var currentTrack: Track? = nil
    @State var currentEpisode: Episode? = nil
    @State var isTrack: Bool = true
    
//    @State var title: String = ""
//    @State var artistNames: [String] = []
//    @State var showName: String = ""
    
    
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
        .onAppear{
            
//            for family in UIFont.familyNames {
//                print(family)
//                for fontName in UIFont.fontNames(forFamilyName: family){
//                    print("-- \(fontName)")
//                }
//            }
            
            switch currentlyPlaying {
            case .track(let track):
                isTrack = true
                currentTrack = track

//                ForEach(currentTrack!.artists) {artist in
//                    artistNames.append(artist.name)
//                }
//                artists = currentTrack.artists!
            case .episode(let episode):
                isTrack = false
                currentEpisode = episode
//                title = episode.name
//                showName = episode.show!.name
            }
            loadImage()
            }
        }
    
    func loadImage() {
        guard let spotifyImage = currentTrack?.album?.images?.first else {
            // print("no image found for '\(playlist.name)'")
            return
        }

        self.loadImageCancellable = spotifyImage.load()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { image in
                    // print("received image for '\(playlist.name)'")
                    self.image = image
                    self.setAverageColor()


                }
            )
    }

     func setAverageColor() {
        let image: Image = self.image // Create an Image anyhow you want
        let uiImage: UIImage = image.asUIImage() // Works Perfectly

         let uiColor = uiImage.averageColor ?? .darkGray

    //    let uiColor = UIImage(named: images[currentIndex])?.averageColor ?? .clear
        backgroundColor = Color(uiColor)
    }
 }



//struct CurrentSongView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrentSongView(track)
//    }
//}
