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
                
                ZStack{
                    Image("ProfilePicBG")
                    .frame(width: 150, height: 150)
                    .background(Color(red: 0.16, green: 0.04, blue: 0.49))
                    .clipShape(Circle())
                    .shadow(color: Color(red: 0.16, green: 0.04, blue: 0.49), radius: 1.0066, x: 0, y: 0)
                    .shadow(color: Color(red: 0.16, green: 0.04, blue: 0.49), radius: 2.01321, x: 0, y: 0)
                    .shadow(color: Color(red: 0.16, green: 0.04, blue: 0.49), radius: 7.04622, x: 0, y: 0)
                    .shadow(color: Color(red: 0.16, green: 0.04, blue: 0.49), radius: 14.09244, x: 0, y: 0)
                    .shadow(color: Color(red: 0.16, green: 0.04, blue: 0.49), radius: 24.15848, x: 0, y: 0)
                    .shadow(color: Color(red: 0.16, green: 0.04, blue: 0.49), radius: 42.27733, x: 0, y: 0)
                    
                    WebImage(url: user.userProfileURL).placeholder{
                        //MARK: Placeholder Image
                        Image("null_pfp")
                            .resizable()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                }
                
                
                
                Text(user.username)
                    .foregroundColor(Color.white)
                    .font(.custom("Inter-SemiBold", size: 36, relativeTo: .largeTitle))
                          
                
                Text(user.userRealName)
                    .foregroundColor(Color.gray)
                    .font(.custom("Inter-Light", size: 18, relativeTo: .caption))
                
                
                
                if self.currentlyPlaying != nil{
                    CurrentSongView(currentlyPlaying: self.currentlyPlaying!, isPlaying: self.isPlaying!)
                }
                
                TasteMeter(value: 78)
                    
                
                
                
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
            }
        }
    }
    
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
                    self.currentlyPlaying = playbackContext?.item
                    isPlaying = playbackContext?.isPlaying
                    
                }
            )
    }
    
}

