//
//  Post.swift
//  Music App
//
//  Created by Jay Sunkara on 7/19/23.
//

import Foundation
import FirebaseFirestoreSwift
import SpotifyWebAPI

struct Post: Identifiable{

    @DocumentID var id: String?
    var text: String
    var track: Track

    var likedIDs: [String] = []
    var nuetralIDs: [String] = []
    var dislikedIDs: [String] = []

    var userName: String
    var userID: String
    var userProfileURL: URL


    enum CodingKeys: CodingKey{
        //Post Content
        case id
        case text
        case track

        //Other user's reactions
        case likedIDs
        case nuetralIDs
        case dislikedIDs

        //Author's Post info
        case userName
        case userUID
        case userProfileURL
    }

}
