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
//import SlidingTabView

struct ReusableProfileContent: View {
    var user: User
    
    @EnvironmentObject var spotify: Spotify
    
    @State private var trackCancellable: AnyCancellable? = nil
    
    
    @State var track: Track? = nil
    @State var isPlaying: Bool? = false
    
    @State var score: CGFloat = 77
    @State var friends: Int = 0
    
    @State var currentlyPlaying: PlaylistItem? = nil
    
    @State var selectedMusic: Bool = true

    
    var body: some View{
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                
                //MARK: Profile Picture
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
                
                
                //MARK: Identifying Info
                Text(user.username)
                    .foregroundColor(Color.white)
                    .font(.custom("Inter-SemiBold", size: 36, relativeTo: .largeTitle))
                    
                    
                Text(user.userRealName)
                    .foregroundColor(Color.gray)
                    .font(.custom("Inter-Light", size: 16, relativeTo: .caption))
                    .padding(.bottom)
                
                Text(String(friends) + " Friends")
                    .foregroundColor(Color.white)
                    .font(.custom("Inter-Regular", size: 18, relativeTo: .caption))
                
                //MARK: Currently Playing - only loads on reload
                if self.currentlyPlaying != nil{
                    CurrentSongView(currentlyPlaying: self.currentlyPlaying!, isPlaying: isPlaying!)
                }
                    //MARK: Taste Meter
                    TasteMeter(value: score)
        
                HStack{
                    Spacer()
                    
                    
                    Button {
                        selectedMusic = true
                    } label: {
                        Image("MusicTab")
                        .frame(width: 32, height: 32)
                    }

                    
                    Spacer()
                    Spacer()
                    Button {
                        selectedMusic = false
                    } label: {
                        Image("FriendsTab")
                        .frame(width: 40, height: 32)
                    }
                    Spacer()
                }
                
                ZStack{
                    
                    //MARK: Separator
                    Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 390, height: 1)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    
                    HStack{
                        
                        if selectedMusic == false{
                            
                        }
                        //MARK: Selected Tab
                        Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 195, height: 3)
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                        
                        Spacer()
                    }
                   
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
                if !user.currentlyPlaying.isEmpty {
                    print(user.currentlyPlaying[0].PlaylistItem.name)
                    
                    self.currentlyPlaying = user.currentlyPlaying[0].PlaylistItem
                    self.isPlaying = user.currentlyPlaying[0].isPlaying
                }
                
                          
                          
            }
            
        }
    }
    
//    func getCurrentTrack() {
//        
//        
//        trackCancellable = self.spotify.api.currentPlayback()
//            .receive(on: RunLoop.main)
//            .sink(
//                receiveCompletion: { completion in
//                    if case .failure(let error) = completion {
//                        print("Error: \(error)")
//                    }
//                },
//                receiveValue: { playbackContext in
//                    self.currentlyPlaying = playbackContext?.item
//                    isPlaying = playbackContext?.isPlaying
//                    
//                }
//            )
//    }
    
}

