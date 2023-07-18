//
//  ProfileView.swift
//  Music App
//
//  Created by Jay Sunkara on 7/6/23.
//
import Combine
import SwiftUI
import SpotifyWebAPI
import CoreData

struct RootView: View {
    
    @Environment (\.managedObjectContext) var managedObjContxt
    @EnvironmentObject var spotify: Spotify
    @State private var cancellables: Set<AnyCancellable> = []
    @State private var alert: Alert? = nil
    @State private var selection = 2
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .forward)]) var users: FetchedResults<MobileUser>
    
    var body: some View {
        TabView(selection: $selection) {
            TestView()
                .tabItem {
                    Label("Test", systemImage: "arrow.triangle.2.circlepath.circle")
                }
                .tag(1)
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(2)
            figma()
                .tabItem {
                    Label("Saved", systemImage: "arrow.triangle.2.circlepath.circle")
                }
                .tag(3)
            
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static let spotify: Spotify = {
        let spotify = Spotify()
        spotify.isAuthorized = true
        return spotify
    }()
    
    static var previews: some View {
        RootView()
            .environmentObject(spotify)
    }
}
