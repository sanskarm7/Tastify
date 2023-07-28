//
//  PostsView.swift
//  Music App
//
//  Created by Jay Sunkara on 7/22/23.
//

import SwiftUI

struct PostsView: View {
    @State private var createNewPost: Bool = false
    @State private var recentsPosts: [Post] = []
    
    var body: some View {
        NavigationStack{
            ReusablePostsView(posts: $recentsPosts)
                .navigationTitle("Posts")
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
