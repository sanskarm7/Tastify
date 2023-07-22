//
//  Post.swift
//  Music App
//
//  Created by Jay Sunkara on 7/19/23.
//

import Foundation
import FirebaseFirestoreSwift
import SpotifyWebAPI

struct Post: Identifiable, Codable{

    @DocumentID var id: String?
//    var text: String
    var track: Track
    var trackName: String

    var likedIDs: [String] = []
    var nuetralIDs: [String] = []
    var dislikedIDs: [String] = []

    var userRealName: String
    var userName: String
    var userUID: String
    var userProfileURL: URL


    private enum CodingKeys: CodingKey{
        //Post Content
        case id
//        case text
        case track
        case trackName

        //Other user's reactions
        case likedIDs
        case nuetralIDs
        case dislikedIDs

        //Author's Post info
        case userRealName
        case userName
        case userUID
        case userProfileURL
    }

}
