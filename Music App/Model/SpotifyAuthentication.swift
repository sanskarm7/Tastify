//
//  SpotifyAuthentication.swift
//  Music App
//
//  Created by Jay Sunkara on 7/6/23.
//
import Foundation
import SpotifyWebAPI
import UIKit
import SwiftUI

final class Spotify: ObservableObject {
    
    @Environment (\.managedObjectContext) var managedObjContxt
    
    //Makes the SpotifyAPI Object w ClinentID/Secret
    let spotifyAPI = SpotifyAPI(
        authorizationManager: AuthorizationCodeFlowManager(
            clientId: "9c0fd040bed64867af0d344e5bed6254", clientSecret: "c1ea3ade2b1840eea2cc5eb4f33f6b74"
        )
    )
    
    /**
     Whether or not the application has been authorized. If `true`, then you can
     begin making requests to the Spotify web API using the `api` property of
     this class, which contains an instance of `SpotifyAPI`.

     When `false`, `LoginView` is presented, which prompts the user to login.
     When this is set to `true`, `LoginView` is dismissed.

     This property provides a convenient way for the user interface to be
     updated based on whether the user has logged in with their Spotify account
     yet. For example, you could use this property disable UI elements that
     require the user to be logged in.

     This property is updated by `authorizationManagerDidChange()`, which is
     called every time the authorization information changes, and
     `authorizationManagerDidDeauthorize()`, which is called every time
     `SpotifyAPI.authorizationManager.deauthorize()` is called.
     */
   
    
    /// If `true`, then the app is retrieving access and refresh tokens. Used by
    /// `LoginView` to present an activity indicator.
    @Published var isRetrievingTokens = false
    
//    @Published var currentUser: SpotifyUser? = nil
    
    
//    var cancellables: Set<AnyCancellable> = []
 
    //Creates Authorization Link
    //Requests for all scopes needed for app featurews
    //Opens Authorization Link in a web browser
    func authorize() {
        
        let url = spotifyAPI.authorizationManager.makeAuthorizationURL(
            redirectURI: URL(string: "musicapp://home")!,
            showDialog: true,
            // This same value **MUST** be provided for the state parameter of
            // `authorizationManager.requestAccessAndRefreshTokens(redirectURIWithQuery:state:)`.
            // Otherwise, an error will be thrown.
//            state: authorizationState,//???
            scopes: [
                .userReadCurrentlyPlaying,
                .ugcImageUpload,
                .userReadPlaybackState,
                .appRemoteControl,
                .playlistModifyPublic,
                .userFollowRead,
                .userReadPlaybackPosition,
                .userTopRead,
                .userReadRecentlyPlayed,
                .userLibraryRead,
                .userReadEmail
            ]
        )!
        
        UIApplication.shared.open(url)
        
        
//        isAuthorized = true
    }
}




