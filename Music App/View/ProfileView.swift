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
    spotify.spotifyAPI.
    
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
                    spotify.spotifyAPI.currentUserTopTracks(TimeRange.shortTerm)
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
                } label: {
                    Text("Get User Top Tracks")
                }
                
                Text("Get Core Data info")
                    .onTapGesture {
                        for x in users{
                            print(users.count)
                            print(x.id ?? 9)
                            print(DataController().status(user: x, context: managedObjContxt)) //shld print false
                            print("\n")
                        }

                    }
                    .navigationTitle("Navigation")
            }
        }
        .onAppear{
            DataController().addUserData(context: managedObjContxt)
            
            if DataController().status(user: users[0], context: managedObjContxt) == false{
                spotify.authorize()
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
                // DataController().modifyIsAuthorize(user: user, context: managedObjContxt)
                DataController().editUserData(user: users[0], context: managedObjContxt, isAuthorized: true, date: users[0].date ?? Date(), url: url)
                print(users.count)
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
