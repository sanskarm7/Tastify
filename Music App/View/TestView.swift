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

struct TestView: View {
    
    @Environment (\.managedObjectContext) var managedObjContxt
    @EnvironmentObject var spotify: Spotify
    @State private var cancellables: Set<AnyCancellable> = []
    
    @State private var alert: AlertItem? = nil          //Xcode cant find AlertItem???


    //    var user = FetchedResults<MobileUser>.Element()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .forward)]) var users: FetchedResults<MobileUser>
    @State private var topSongs: [Track] = []
    
    var body: some View {
        
            VStack(){
         
                Button{
//
//
//                    print("Refresh Token ",spotify.spotifyAPI.authorizationManager.refreshToken)
//                    print("Access Token ",spotify.spotifyAPI.authorizationManager.accessToken)
//
//
//                    guard let tempURL = users[0].url else{
//                        return
//                    }
//                    print("Button has been clicked, URL: ",users[0].url!)
//                    print("authorizationState: ", spotify.authorizationState)
//                    print(spotify.spotifyAPI.authorizationManager.didDeauthorize)
//                    spotify.spotifyAPI.authorizationManager.requestAccessAndRefreshTokens(
//                        redirectURIWithQuery: tempURL,
//                        state: DataController().getAuthState(user: users[0], context: managedObjContxt)
//                    )
//                    .sink(receiveCompletion: { completion in
//                        switch completion {
//                        case .finished:
//                            print("This Ran")
//                        case .failure(let error):
//                            if let authError = error as? SpotifyAuthorizationError, authError.accessWasDenied {
//                                print("The user denied the authorization request")
//                            }
//                            else {
//                                print("couldn't authorize application: \(error)")
//                            }
//                        }
//                    })
//                    .store(in: &cancellables)
//                    checkTokens()
//
//                    print("Refresh Token ",spotify.spotifyAPI.authorizationManager.refreshToken)
//                    print("Access Token ",spotify.spotifyAPI.authorizationManager.accessToken)
                    
                    spotify.api.currentUserTopTracks(TimeRange.shortTerm)
                        .sink(
                            receiveCompletion: { completion in
                                print(completion)
                            },
                            receiveValue: { results in
                                topSongs = results.items

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


            }
        
        .onOpenURL(perform: handleURL(_:))
        .onAppear{
            if spotify.isAuthorized == false{
                spotify.authorize()
            }
            
//            DataController().addUserData(context: managedObjContxt)
            
//            if DataController().status(user: users[0], context: managedObjContxt) == false{
//                spotify.authorize()
//            }
        }
    }
    
//    func checkTokens(){
//
//        //First check if accessToken is expired
//        if(spotify.spotifyAPI.authorizationManager.accessTokenIsExpired()){
//            //Refresh the Access Token
//
//            spotify.spotifyAPI.authorizationManager.refreshTokens(onlyIfExpired: false).sink(receiveCompletion: { completion in
//
//                print("refresh tokens completion: \(completion)")
//
//            })
//            .store(in: &cancellables)
//        }
//            // do checktokens then handleURl
//
//        handleURL(DataController().getURL(user: users[0], context: managedObjContxt))
//
//    }
    
    func handleURL(_ url: URL) {
        
        // **Always** validate URLs; they offer a potential attack vector into
        // your app.
        
        //Xcode cant find AlertItem???
        guard url.scheme == self.spotify.loginCallbackURL.scheme else {
            print("not handling URL: unexpected scheme: '\(url)'")
            self.alert = AlertItem(
                title: "Cannot Handle Redirect",
                message: "Unexpected URL"
            )
            return
        }
        
        print("received redirect from Spotify: '\(url)'")
        
        // This property is used to display an activity indicator in `LoginView`
        // indicating that the access and refresh tokens are being retrieved.
        spotify.isRetrievingTokens = true
        
        // Complete the authorization process by requesting the access and
        // refresh tokens.
        spotify.api.authorizationManager.requestAccessAndRefreshTokens(
            redirectURIWithQuery: url,
            // This value must be the same as the one used to create the
            // authorization URL. Otherwise, an error will be thrown.
            state: spotify.authorizationState
        )
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
            // Whether the request succeeded or not, we need to remove the
            // activity indicator.
            self.spotify.isRetrievingTokens = false
            
            /*
             After the access and refresh tokens are retrieved,
             `SpotifyAPI.authorizationManagerDidChange` will emit a signal,
             causing `Spotify.authorizationManagerDidChange()` to be called,
             which will dismiss the loginView if the app was successfully
             authorized by setting the @Published `Spotify.isAuthorized`
             property to `true`.

             The only thing we need to do here is handle the error and show it
             to the user if one was received.
             */
            if case .failure(let error) = completion {
                print("couldn't retrieve access and refresh tokens:\n\(error)")
                let alertTitle: String
                let alertMessage: String
                if let authError = error as? SpotifyAuthorizationError,
                   authError.accessWasDenied {
                    alertTitle = "You Denied The Authorization Request :("
                    alertMessage = ""
                }
                else {
                    alertTitle =
                        "Couldn't Authorization With Your Account"
                    alertMessage = error.localizedDescription
                }
                self.alert = AlertItem(
                    title: alertTitle, message: alertMessage
                )
            }
        })
        .store(in: &cancellables)
        
        // MARK: IMPORTANT: generate a new value for the state parameter after
        // MARK: each authorization request. This ensures an incoming redirect
        // MARK: from Spotify was the result of a request made by this app, and
        // MARK: and not an attacker.
        self.spotify.authorizationState = String.randomURLSafe(length: 128)
        
    }
    
//    func oldHandleURL(_ url: URL){
//        spotify.spotifyAPI.authorizationManager.requestAccessAndRefreshTokens(
//            redirectURIWithQuery: url,
//            state: spotify.authorizationState
//        )
//        .sink(receiveCompletion: { completion in
//            switch completion {
//            case .finished:
//                // DataController().modifyIsAuthorize(user: user, context: managedObjContxt)
//                DataController().editUserData(user: users[0], context: managedObjContxt, isAuthorized: true, date: users[0].date ?? Date(), url: url, authState: spotify.authorizationState)
//                print("User's URL: ", url)
//                print("URL saved on CoreData: ", DataController().getURL(user: users[0], context: managedObjContxt))
//                print("successfully authorized")
//            case .failure(let error):
//                if let authError = error as? SpotifyAuthorizationError, authError.accessWasDenied {
//                    print("The user denied the authorization request")
//                }
//                else {
//                    print("couldn't authorize application: \(error)")
//                }
//            }
//        })
//        .store(in: &cancellables)
//
//    }
}

struct TestView_Previews: PreviewProvider {
    static let spotify: Spotify = {
        let spotify = Spotify()
        spotify.isAuthorized = true
        return spotify
    }()
    
    static var previews: some View {
        TestView()
            .environmentObject(spotify)
    }
}
