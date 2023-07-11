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
    
    @Environment (\.managedObjectContext) var managedObjContxt
    @EnvironmentObject var spotify: Spotify
    @State private var cancellables: Set<AnyCancellable> = []
    
    var body: some View {
        //pink tape - spotify:album:2ua5bFkZLZl1lIgKWtYZIz
//        spotify.spotifyAPI
        NavigationView {
            Text("This is the Profile View")
                .onTapGesture {
                    spotify.spotifyAPI.currentUserTopTracks(TimeRange.longTerm)
                        .sink(
                            receiveCompletion: { completion in
                                print(completion)
                            },
                            receiveValue: { results in
                                for item in results.items{
                                    print(item.name)
                                }
                                            
                            }
                        )
                        .store(in: &cancellables)
                }
                .navigationTitle("Navigation")
        }
        .onAppear{
            if DataController().status(context: managedObjContxt) == false{
                spotify.authorize()
                DataController().authorization(context: managedObjContxt)
            }
        }
//        .onAppear{
//            if spotify.isAuthorized == false{
//                spotify.authorize()
//            }
//
//        }
        .onOpenURL(perform: handleURL(_:))
  
        }

        
        func handleURL(_ url: URL){
            
            spotify.spotifyAPI.authorizationManager.requestAccessAndRefreshTokens(
                redirectURIWithQuery: url
            )
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                  //  spotify.isAuthorized = true
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
