//
//  Post.swift
//  Music App
//
//  Created by Jay Sunkara on 7/19/23.
//
//import SwiftUI
import Foundation
import FirebaseFirestoreSwift
import SpotifyWebAPI

struct Post: Identifiable, Codable, Equatable, Hashable{

    @DocumentID var id: String?
//    var text: String
    var track: Track
    var albumImageURL: URL?
    var imageReferenceID: String = ""
    var imageColor: [CGFloat] = []
    
    var likedIDs: [String] = []
    var neutralIDs: [String] = []
    var dislikedIDs: [String] = []

    var userName: String
    var userUID: String
    var userProfileURL: URL
    
    var publishedDate: Date = Date()


    private enum CodingKeys: CodingKey{
        //Post Content
        case id
//        case text
        case track
        case albumImageURL
        case imageReferenceID
        case imageColor
        

        
        //Other user's reactions
        case likedIDs
        case neutralIDs
        case dislikedIDs

        //Author's Post info
        case userName
        case userUID
        case userProfileURL
        
        case publishedDate
    }

}
