//
//  Music_AppApp.swift
//  Music App
//
//  Created by Sanskar Mishra on 7/4/23.
//

import SwiftUI
import Firebase

@main
struct Music_AppApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
