//
//  SearchFriendsView.swift
//  Music App
//
//  Created by Jay Sunkara on 8/3/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import SpotifyWebAPI
import Combine

struct SearchFriendsView: View {
    
    
    
    @State private var isSearching = false
    

    
    @State private var fetchedUsers: [User] = []
    @State private var searchText = ""
    
    
    
    
    var body: some View {
        NavigationView {
            ZStack{
    //            Color(red: 0.03, green: 0, blue: 0.09).edgesIgnoringSafeArea(.all)

                VStack {
                    searchBar
                        .padding([.top, .horizontal])
        //            Text("Tap on a track to play it.")
        //                .font(.caption)
        //                .foregroundColor(.secondary)
                    Spacer()
                    if fetchedUsers.isEmpty {
                        if isSearching {
                            HStack {
                                ProgressView()
                                    .padding()
                                Text("Searching")
                                    .font(.title)
                                    .foregroundColor(.secondary)
                            }
                            
                        }
                        else {
                            Text("No Results for Friends")
                                .font(.title)
                                .foregroundColor(.secondary)
                        }
                    }
                    else {
                        List {
                            ForEach(fetchedUsers) { user in
                                NavigationLink{
                                    ZStack{
                                        Color(red: 0.03, green: 0, blue: 0.09).edgesIgnoringSafeArea(.all)
                                        
                                        ReusableProfileContent(user: user)
                                    }
                                } label: {
                                    Text(user.username)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                    Spacer()
                }
//                .navigationTitle("Search For Tracks")

            }
        }
        

    }
    
    /// A search bar. Essentially a textfield with a magnifying glass and an "x"
    /// button overlayed in front of it.
    var searchBar: some View {
        // `onCommit` is called when the user presses the return key.

        TextField("Find Friends", text: $searchText)
            .textCase(.lowercase)
//            .searchable(text: $searchText)
            .onSubmit{
                
                Task{await searchUsers()}
            }
//            .onChange(of: searchText, perform: { newValue in
//                if newValue.isEmpty{
//                    fetchedUsers = []
//                }
//            })
            .padding(.leading, 22)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    Spacer()
                    if !searchText.isEmpty {
                        // Clear the search text when the user taps the "x"
                        // button.
                        Button(action: {
                            self.searchText = ""
                            fetchedUsers = []
//                            self.tracks = []
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        })
                    }
                }
            )
            .padding(.vertical, 7)
            .padding(.horizontal, 7)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
    }
    
    //SEARCH BY USERNAME
    func searchUsers()async {
        do{
            
//            let queryLowerCased = searchText.lowercased()
//            let queryUpperCased = searchText.uppercased()
            
            let documents = try await Firestore.firestore().collection("Users")
//                .whereField("username", isGreaterThan: searchText.lowercased())
                .whereField("username", isLessThan: "\(searchText.lowercased())\u{f8ff}")
                .order(by: "username", descending: true)
                .getDocuments()
            print("Documents.count: ", documents.count)
            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
            }
            print("users.count: ", users.count)

            await MainActor.run(body: {
                fetchedUsers = users
                print("fetchedUsers.count: ", fetchedUsers.count)
                print("\n")

            })
        } catch{
            print(error.localizedDescription)
        }
    }
    
}

struct SearchFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFriendsView()
    }
}
