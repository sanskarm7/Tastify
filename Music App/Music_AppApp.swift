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
    
   
    
    @StateObject var spotify = Spotify()
    @StateObject private var dataController = DataController()

    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(spotify)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
