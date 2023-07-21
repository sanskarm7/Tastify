//
//  User.swift
//  Music App
//
//  Created by Sanskar Mishra on 7/5/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var userRealName: String
    //var userBioLink: String
    var userUID: String
    var userEmail:String
    var userProfileURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case username
        case userRealName
        //case userBioLink
        case userUID
        case userEmail
        case userProfileURL
    }
}
