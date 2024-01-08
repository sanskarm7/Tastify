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
            Color(red: 0.03, green: 0, blue: 0.09).edgesIgnoringSafeArea(.all) //BACKGROUND
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
