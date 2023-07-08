//
//  ProfileView.swift
//  Music App
//
//  Created by Jay Sunkara on 7/6/23.
//
import Combine
import SwiftUI
import SpotifyWebAPI


struct ProfileView: View {
    
    @EnvironmentObject var spotify: Spotify
    @State private var cancellables: Set<AnyCancellable> = []
    
    var body: some View {
        
        NavigationView {
            Text("This is the Profile View")
                .navigationTitle("Navigation")
        }
        .onAppear{
            if spotify.isAuthorized == false{
                spotify.authorize()
            }
            
        }
        .onOpenURL(perform: handleURL(_:))
  
        }

        
        func handleURL(_ url: URL){
            
            spotify.spotifyAPI.authorizationManager.requestAccessAndRefreshTokens(
                redirectURIWithQuery: url
            )
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("successfully authorized")
                case .failure(let error):
                    if let authError = error as? SpotifyAuthorizationError, authError.accessWasDenied {
                        print("The user denied the authorization request")
                    }
                    else {
                        print("couldn't authorize application: \(error)")
                    }
                }
            })
            .store(in: &cancellables)
        }
    }

    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
        }
    }
