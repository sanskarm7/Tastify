//
//  Friends.swift
//  Music App
//
//  Created by Sanskar Mishra on 9/2/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import SpotifyWebAPI

struct Friends: Identifiable, Codable {
    
    @DocumentID var id: String?
    
    //Outgoing Requests
    var outgoingRequests: [String]
    
    //Incoming Requests
    var incomingRequests: [String]
    
    //Friends
    var friends: [String]
    
    
    enum CodingKeys: CodingKey {
        case id
        case outgoingRequests
        case incomingRequests
        case friends
       
    }
}
