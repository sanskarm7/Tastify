//
//  ReusablePostsView.swift
//  Music App
//
//  Created by Jay Sunkara on 7/22/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct ReusablePostsView: View {
    @Binding var posts: [Post]
    @State var isFetching: Bool = true
    @State private var paginationDoc: QueryDocumentSnapshot?
    
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
//            .onAppear{
//                //when last post appears, fetch new post (if there)
//                if post.id == posts.last?.id && paginationDoc != nil{
//                    Task{await fetchPosts()}
//                }
//            }
//            VStack{
//                Text("User: " + post.userName)
//                Text("Song: " + post.trackName)
//                Text("\n")
//            }
        }
    }
    
    func fetchPosts()async{
        do{
            var query: Query!
            
            //pagination
//            if let paginationDoc{
//                query = Firestore.firestore().collection("Posts")
//                    .order(by: "publishedDate", descending: true)
//                    .start(afterDocument: paginationDoc)
//                    .limit(to: 5)
//            } else{
//                query = Firestore.firestore().collection("Posts")
//                    .order(by: "publishedDate", descending: true)
//                    .limit(to: 20)
//            }
            query = Firestore.firestore().collection("Posts")
                .order(by: "publishedDate", descending: true)
//                .limit(to: 20)
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
            }
            await MainActor.run(body: {
                
                posts.append(contentsOf: fetchedPosts)

                paginationDoc = docs.documents.last
                isFetching = false
            })
        } catch{
            print(error.localizedDescription)
        }

    }

}

//struct ReusablePostsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReusablePostsView()
//    }
//}
