//
//  ProfileView.swift
//  Music App
//
//  Created by Jay Sunkara on 7/6/23.
//
import Combine
import SwiftUI
import SpotifyWebAPI
import CoreData

struct ProfileView: View {
    
    @Environment (\.managedObjectContext) var managedObjContxt
    @EnvironmentObject var spotify: Spotify
    @State private var cancellables: Set<AnyCancellable> = []
    //    var user = FetchedResults<MobileUser>.Element()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .forward)]) var users: FetchedResults<MobileUser>
    @State private var showingPopover = false
    @State private var topSongs: [Track] = []
    
    var body: some View {
        //        spotify.spotifyAPI
        NavigationView {
            VStack(spacing: 20){
                
                Button {
                    DataController().addUserData(context: managedObjContxt)
                } label: {
                    Text("Add User")
                }
                
                Button {
                    DataController().modifyIsAuthorize(user: users[0], context: managedObjContxt)
                } label: {
                    Text("Change isAuthorized")
                }
                
                Button{
//                    self.spotify.authorizationState = String.randomURLSafe(length: 128)
                    
                    guard let tempURL = users[0].url else{
                        return
                    }
                    print("Button has been clicked, URL: ",users[0].url!)
                    print("authorizationState: ", spotify.authorizationState)
//                    print(spotify.spotifyAPI.authorizationManager.didDeauthorize)
                    spotify.spotifyAPI.authorizationManager.requestAccessAndRefreshTokens(
                        redirectURIWithQuery: tempURL,
                        state: DataController().getAuthState(user: users[0], context: managedObjContxt)
                    )
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            print("This Ran")
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
                    
                    
                    spotify.spotifyAPI.currentUserTopTracks(TimeRange.shortTerm)
                        .sink(
                            receiveCompletion: { completion in
                                print(completion)
                            },
                            receiveValue: { results in
                                topSongs = results.items
                                showingPopover = true

                                for item in results.items{
                                    print(item.name)
                                }
                            }
                        )
                        .store(in: &cancellables)
                    print("After tokens, did this run?")

                } label: {
                    Text("Get User Top Tracks")
                }
                    List(topSongs, id:\.self) { song in
                                        Text(song.name)
                    }

                
                Text("Get Core Data info")
                    .onTapGesture {
                        for x in users{
                            print("Number of users: ",users.count)
                            print("User's UUID: ",x.id ?? 9)
                            print("isAuthorized is ", DataController().status(user: x, context: managedObjContxt))
                            print("URL: ", DataController().getURL(user: x, context: managedObjContxt))
                            print("\n")
                        }
                    }
                    .navigationTitle("Navigation")
            }
        }
        .onOpenURL(perform: handleURL(_:))
        .onAppear{
            DataController().addUserData(context: managedObjContxt)
            
            if DataController().status(user: users[0], context: managedObjContxt) == false{
                spotify.authorize()
            }
        }
    }
    
    func handleURL(_ url: URL){
        
        spotify.spotifyAPI.authorizationManager.requestAccessAndRefreshTokens(
            redirectURIWithQuery: url,
            state: spotify.authorizationState
        )
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                // DataController().modifyIsAuthorize(user: user, context: managedObjContxt)
                DataController().editUserData(user: users[0], context: managedObjContxt, isAuthorized: true, date: users[0].date ?? Date(), url: url, authState: spotify.authorizationState)
                print("User's URL: ", url)
                print("URL saved on CoreData: ", DataController().getURL(user: users[0], context: managedObjContxt))
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
