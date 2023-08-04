//
//  SearchView.swift
//  Music App
//
//  Created by Jay Sunkara on 8/3/23.
//

import SwiftUI

struct SearchView: View {
    
    @State private var isShowingSearchSongView = true
    
    var body: some View {
        ZStack{
            
            if(isShowingSearchSongView){
                SearchSongView()
            }
            else{
                SearchFriendsView()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button{
                        isShowingSearchSongView.toggle()
                    } label: {
                        Image(systemName: "shuffle.circle.fill")
                            .font(.system(size: 50))
                            .padding()
                            .foregroundColor(Color.purple)
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
