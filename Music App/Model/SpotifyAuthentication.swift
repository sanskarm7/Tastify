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
    

    var authorizationState = String.randomURLSafe(length: 128)

    @Published var isRetrievingTokens = false

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
            state: authorizationState,
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




