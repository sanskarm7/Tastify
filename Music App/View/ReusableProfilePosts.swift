//
//  ReusableProfilePosts.swift
//  Music App
//
//  Created by Sanskar Mishra on 8/23/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct ReusableProfilePosts: View {
    @State var posts: [Post] = []
    @State var isFetching: Bool = true
    @State private var paginationDoc: QueryDocumentSnapshot?
    var user : User
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack{
                if isFetching{
                    ProgressView()
                        .padding(.top, 30)
                } else{
                    if posts.isEmpty{
                        Text("No Posts yet\nCreate posts by going to the search tab to find songs and add friends")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding()
                    } else{
                        //Displaying Posts
                        Posts()
                    }
                }
            }
        }
        .refreshable{
            isFetching = true
            posts = []
            await fetchPosts()
        }
        .task{
            guard posts.isEmpty else{return}
            await fetchPosts()
            
        }
    }
    
    func Posts()->some View{
        ForEach(posts){ post in
            
            PostCardView(post: post){ updatedPost in
                if let index = posts.firstIndex(where: { post in
                    post.id == updatedPost.id
                }){
                    posts[index].likedIDs = updatedPost.likedIDs
                    posts[index].neutralIDs = updatedPost.neutralIDs
                    posts[index].dislikedIDs = updatedPost.dislikedIDs
                }
                
            } onDelete: {
                withAnimation(.easeInOut(duration: 0.25)){
                    posts.removeAll{post.id == $0.id}
                }
            }

        }
    }
    
    func fetchPosts()async{
        do{
            var query: Query!

            query = Firestore.firestore().collection("Posts")
                .order(by: "publishedDate", descending: true)
//                .limit(to: 20)
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
            }
            await MainActor.run(body: {
                var tempPosts: [Post] = []
                for p in fetchedPosts{
                    if(p.userUID == user.userUID){
                        tempPosts.append(p)
                    }
                }

                posts.append(contentsOf: tempPosts)

                paginationDoc = docs.documents.last
                isFetching = false
            })
        } catch{
            print(error.localizedDescription)
        }

    }

}


//struct ReusableProfilePosts_Previews: PreviewProvider {
//    static var previews: some View {
//        ReusableProfilePosts()
//    }
//}
