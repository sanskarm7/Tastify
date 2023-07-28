//
//  ReusableProfileContent.swift
//  Music App
//
//  Created by Sanskar Mishra on 7/18/23.
//

import SwiftUI
import SDWebImageSwiftUI
import SpotifyWebAPI
import Combine

struct ReusableProfileContent: View {
    var user: User
    
    @EnvironmentObject var spotify: Spotify
    
    @State private var trackCancellable: AnyCancellable? = nil
    
    
    @State var track: Track? = nil
    @State var isPlaying: Bool? = false
    
    @State var currentlyPlaying: PlaylistItem? = nil

    
    var body: some View{
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                WebImage(url: user.userProfileURL).placeholder{
                    //MARK: Placeholder Image
                    Image("null_pfp")
                        .resizable()
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                
                Text(user.username)
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .fontWeight(.semibold)
                
                Text(user.userRealName)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                
                
                if self.currentlyPlaying != nil{
                    CurrentSongView(currentlyPlaying: self.currentlyPlaying!, isPlaying: self.isPlaying!)
                }
                
                
                
                //MARK: Displaying Bio Link, if given while signing up
                
//                if let bioLink = URL(string: user.userBioLink){
//                    Link(user.userBioLink, destination: bioLink)
//                        .font(.callout)
//                        .tint(.blue)
//                        .lineLimit(1)
//                }
            }
            
            .onAppear{
                
                getCurrentTrack()
                
//                if playbackContext != nil {
//                    print("Not null")
//                }
            }
        }
    }
    
//    //func getTrack() {
//
//        trackCancellable = spotify.api.track("spotify:track:7lEptt4wbM0yJTvSG5EBof")
//            .receive(on: RunLoop.main)
//            .sink(
//                receiveCompletion: { completion in
//                    if case .failure(let error) = completion {
//                        print("Error: \(error)")
//                    }
//                },
//                receiveValue: { track in
//                    print(track)
//                    self.track = track
//                }
//            )
//
//    }
    func getCurrentTrack() {
        
        
        trackCancellable = self.spotify.api.currentPlayback()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error: \(error)")
                    }
                },
                receiveValue: { playbackContext in
                    print("this gets called")
                   // print(playbackContext!.device.isActive)
//                    if playbackContext?.itemType.rawValue == "track" {
//                        self.track = playbackContext?.item
//                    }
                    self.currentlyPlaying = playbackContext?.item
                    isPlaying = playbackContext?.isPlaying
                    
                    //print(playbackContext?.device)
                    //print(currentlyPlaying?.name)
                    
                }
            )
    }
    
}

