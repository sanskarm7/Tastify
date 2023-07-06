//
//  SpotifyAuthentication.swift
//  Music App
//
//  Created by Jay Sunkara on 7/6/23.
//

import Foundation
import SpotifyWebAPI
import UIKit

let spotify = SpotifyAPI(
    authorizationManager: AuthorizationCodeFlowManager(
        clientId: "9c0fd040bed64867af0d344e5bed6254", clientSecret: "c1ea3ade2b1840eea2cc5eb4f33f6b74"
    )
)

let authorizationURL = spotify.authorizationManager.makeAuthorizationURL(
    redirectURI: URL(string: "musicapp://home")!,
    showDialog: false,
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

